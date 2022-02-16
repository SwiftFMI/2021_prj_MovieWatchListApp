import Foundation

class MovieService {
    
    static let shared = MovieService()
    private init() {}

    func searchMovie(id: Int, successHandler: @escaping (Movie) -> Void, errorHandler: @escaping (SearchError) -> Void) {
        fetchEntity(from: ApiRequest.fetchMovieByID(id), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func searchMovie(query: String, successHandler: @escaping (MovieSearch) -> Void, errorHandler: @escaping (SearchError) -> Void) {
        fetchEntity(from: ApiRequest.searchMovieByText(query), successHandler: successHandler, errorHandler: errorHandler)
    }
}





