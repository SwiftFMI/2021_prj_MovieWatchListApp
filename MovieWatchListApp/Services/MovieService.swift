import Foundation
import Alamofire
import UIKit
class MovieService {
    
    static let shared = MovieService()
    private init() {}
    
    func getMovie(id: Int) -> Movie? {
        var movie: Movie? = nil
        let url:String = "\(ApiRequest.baseURL)/movie/\(id)?api_key=\(ApiRequest.apiKey)"
        let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
        
        AF.request(url,headers: headers)
            .responseDecodable(of: Movie.self) { response in
                switch response.result {
                case .success:
                    movie = response.value
                    print(movie?.title)
                case .failure:
                    print(response.error?.localizedDescription)
                }
            }
        return  movie ?? nil
    }

    func searchMovie(query: String) -> MovieSearch? {
            var movieSearchResult: MovieSearch? = nil
            let url:String = "\(ApiRequest.baseURL)/search/movie?query=\(query)&api_key=\(ApiRequest.apiKey)"
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
    
    func getImage(posterPath: String) -> UIImage? {
        var image: UIImage?
        AF.download("https://image.tmdb.org/t/p/w500\(posterPath)")
            .responseData { response in
                if let data = response.value {
                    image = UIImage(data: data)
                }
            }
        return image
    }
    
    //    func searchMovie(query: String, successHandler: @escaping (MovieSearch) -> Void, errorHandler: @escaping (SearchError) -> Void) {
    //        fetchEntity(from: ApiRequest.searchMovieByText(query), successHandler: successHandler, errorHandler: errorHandler)
    //    }
}





