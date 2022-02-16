import Foundation
import Alamofire
class MovieService {
    
    static let shared = MovieService()
    private init() {}
    
    func searchMovie(id: Int, successHandler: @escaping (Movie) -> Void, errorHandler: @escaping (SearchError) -> Void) {
        fetchEntity(from: ApiRequest.fetchMovieByID(id), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func searchMovie(query: String) -> MovieSearch? {
        var movieSearchResult: MovieSearch? = nil
        let url:String = "\(ApiRequest.baseURL)" + "/search/movie?" + "query=\(query)" + "&api_key=\(ApiRequest.apiKey)"
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
    //    func searchMovie(query: String, successHandler: @escaping (MovieSearch) -> Void, errorHandler: @escaping (SearchError) -> Void) {
    //        fetchEntity(from: ApiRequest.searchMovieByText(query), successHandler: successHandler, errorHandler: errorHandler)
    //    }
}





