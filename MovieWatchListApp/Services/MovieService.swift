import Foundation
import Alamofire
import Firebase
import FirebaseFirestore
class MovieService {
    
    let baseURL:String = "https://api.themoviedb.org/3"
    var apiKey = Utilities.getApiKey()
    
    static let shared = MovieService()
    private init() {}
    
    func getMovie(id: Int) -> Movie? {
        var movie: Movie? = nil
        let url:String = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
        AF.request(url)
            .responseDecodable(of: Movie.self) { response in
                switch response.result {
                case .success:
                    movie = response.value
                case .failure:
                    print(response.error?.localizedDescription ?? "")
                }
            }
        return  movie ?? nil
    }
    
    func searchMovie(query: String) -> MovieSearch? {
        var movieSearchResult: MovieSearch? = nil
        let url:String = "\(baseURL)/search/movie?query=\(query)&api_key=\(apiKey)"
        let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
        AF.request(url,headers: headers)
            .responseDecodable(of: MovieSearch.self) { response in
                switch response.result {
                case .success:
                    movieSearchResult = response.value
                    print(movieSearchResult?.results[0].title)
                case .failure:
                    print(response.error?.localizedDescription)
                }
            }
        return  movieSearchResult ?? nil
    }
    
    func getMovieDb(movieId:Int) -> Movie? {
        var movieResult: Movie?
        let db = Firestore.firestore()
        db.collection("movies")
            .whereField("movieId", isEqualTo: movieId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error)
                } else if let snapshot = snapshot {
                    let movies = snapshot.documents.compactMap {
                        movieResult =  try? $0.data(as: Movie.self)
                    }
                }
            }
        return movieResult
    }
    
    func setMovieDb(movie:Movie) -> Bool {
        let db = Firestore.firestore()
        do {
            try db.collection("movies").document(movie.id!).setData(from: movie)
            return true
        } catch {
            print(error)
            return false
        }
    }
}






