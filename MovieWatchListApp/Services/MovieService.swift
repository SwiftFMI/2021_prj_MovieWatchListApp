import Foundation
import Alamofire
import Firebase
import FirebaseFirestore
class MovieService {
    
    let baseURL:String = "https://api.themoviedb.org/3"
    var apiKey = Utilities.getApiKey()
    
    typealias moviesCallBack = (_ countries:MovieSearch?, _ status: Bool, _ message:String) -> Void
    typealias movieCallBack = (_ countries:Movie?, _ status: Bool, _ message:String) -> Void
    
    var searchCallBack:moviesCallBack?
    var movieDeatailsCallBack: movieCallBack?
    
    static let shared = MovieService()
    private init() {}
    
    func getMovie(id: Int) {
        let url:String = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        let headers:HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")]
        AF.request(url,headers: headers)
            .responseDecodable(of: Movie.self) { (response) in
                guard let _ = response.data else {
                    self.movieDeatailsCallBack?(nil, false, "")
                    return}
                do {
                    let movie = response.value
                    self.movieDeatailsCallBack?(movie, true,"Success!")
                }
                
            }
    }
    
    func searchMovie(query: String) {
        let url:String = "\(baseURL)/search/movie?query=\(query)&api_key=\(apiKey)"
        let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
        AF.request(url,headers: headers)
            .responseDecodable(of: MovieSearch.self) { response in
                
                guard let _ = response.data else {
                    self.searchCallBack?(nil, false, "")
                    return}
                do {
                    let movieSearch = response.value
                    self.searchCallBack?(movieSearch, true,"Success!")
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
                        self.movieDeatailsCallBack?(movieResult, true,"Success!")
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
    
    func completionHandlerDetails(callBack: @escaping movieCallBack) {
        self.movieDeatailsCallBack = callBack
    }
    func completionHandlerSearch(callBack: @escaping moviesCallBack) {
        self.searchCallBack = callBack
    }
}







