import Foundation
import Alamofire
import Firebase
import FirebaseFirestore
class MovieService {

    private init() {}
    static let shared = MovieService()
    
    let baseURL:String = "https://api.themoviedb.org/3"
    var apiKey = Utilities.getApiKey()
    
    typealias moviesCallBack = (_ movies:MovieSearch?, _ status: Bool, _ message:String) -> Void
    typealias movieDetailsCallBack = (_ movies:Movie?, _ status: Bool, _ message:String) -> Void
    
    var movieSearchCallBack: moviesCallBack?
    var movieDetailsCallBack: movieDetailsCallBack?
    
    func completionHandlerDetails(callBack: @escaping movieDetailsCallBack) {
        self.movieDetailsCallBack = callBack
    }
    
    func completionHandlerSearch(callBack: @escaping moviesCallBack) {
        self.movieSearchCallBack = callBack
    }
    
    let headers:HTTPHeaders = [
        .accept("application/json"),
        .contentType("application/json")]
    
    func getMovie(id: Int) {
        let url:String = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: Movie.self) { (response) in
                guard let _ = response.data else {
                    self.movieDetailsCallBack?(nil, false, "")
                    return}
                do {
                    let movie = response.value
                    self.movieDetailsCallBack?(movie, true,"Success!")
                }
                
            }
    }
    
    func searchMovie(query: String) {
        var queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let url:String = "\(baseURL)/search/movie?query=\(queryEncoded!)&api_key=\(apiKey)"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: MovieSearch.self) { response in
                
                guard let _ = response.data else {
                    self.movieSearchCallBack?(nil, false, "")
                    return}
                do {
                    let movieSearch = response.value
                    self.movieSearchCallBack?(movieSearch, true,"Success!")
                }
            }
    }
    
    func getMovieDb(movieId:Int) {
        var movieResult: Movie?
        let db = Firestore.firestore()
        db.collection("movies")
            .whereField("id", isEqualTo: movieId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error)
                } else if let snapshot = snapshot {
                    let _ = snapshot.documents.compactMap {
                        movieResult =  try? $0.data(as: Movie.self)
                        self.movieDetailsCallBack?(movieResult, true,"Success!")
                    }
                }
            }
    }
    
    func setMovieDb(movie:Movie) {
        let db = Firestore.firestore()
        db.collection("movies")
            .whereField("id", isEqualTo: movie.movieId)
            .getDocuments() { (snapshot, error) in
                if snapshot?.count != 0  {
                    print("Already exists!")
                } else {
                    do {
                        try db.collection("movies").document(movie.uid!).setData(from: movie)
                    } catch {
                        print(error)
                    }
                }
            }
    }
    
    func discoverByGennres(genresId: [Int],page: Int = 1) {
        var genresQuery: String = (genresId.map{String($0)}).joined(separator: ",")
        let url:String = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genresQuery)&language=en-US&page=\(page)&sort_by=popularity.desc"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: MovieSearch.self) { response in
                
                guard let _ = response.data else {
                    self.movieSearchCallBack?(nil, false, "")
                    return}
                do {
                    let movieSearch = response.value
                    self.movieSearchCallBack?(movieSearch, true,"Success!")
                }
            }
    }

    func popularMovies(page: Int = 1) {
        let url:String = "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)&sort_by=popularity.desc"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: MovieSearch.self) { response in
                
                guard let _ = response.data else {
                    self.movieSearchCallBack?(nil, false, response.error?.localizedDescription ?? "")
                    return}
                do {
                    let movieSearch = response.value
                    self.movieSearchCallBack?(movieSearch, true,"Success!")
                }
            }
    }
    
}







