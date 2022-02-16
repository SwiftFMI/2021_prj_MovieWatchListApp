import Foundation
import Alamofire

class MovieService {
    
    static let shared = MovieService()
    
    private init() {}
    
    
    func fetchMovies(completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        
    }
    //    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    //    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    //
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

public enum ApiRequest: URLRequestConvertible {
    
    enum Constants {
        static let baseURL = "https://api.themoviedb.org/3"
        static let jsonDecoder = Utilities.jsonDecoder
        static var apiKey = Utilities.getApiKey()
    }
    
    case fetchMovieByID(Int)
    case searchByText(String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    var path: String {
        
        switch self {
        case .fetchMovieByID(let id):
            return "/movie/\(id)"
        case .searchByText:
            return "/search/movie"
        }
        
    }
    var parameters: [String: Any] {
        return ["api_key": Constants.apiKey]
    }
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

