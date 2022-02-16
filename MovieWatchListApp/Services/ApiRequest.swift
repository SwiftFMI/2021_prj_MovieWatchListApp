import Foundation
import Alamofire

public enum ApiRequest: URLRequestConvertible {
    
    static let baseURL:String = "https://api.themoviedb.org/3"
    static let jsonDecoder = Utilities.jsonDecoder
    static var apiKey = Utilities.getApiKey()
    
    case fetchSeriesByID(Int)
    case searchSeriesByText(String)
    case fetchMovieByID(Int)
    case searchMovieByText(String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    public var path: String {
        switch self {
        case .fetchSeriesByID(let id):
            return "/tv/\(id)"
        case .searchSeriesByText:
            return "/search/tv"
        case .fetchMovieByID(let id):
            return "/movie/\(id)"
        case .searchMovieByText:
            return "/search/movie"
        }
        
    }
    
    var parameters: [String: Any] {
        return ["api_key": ApiRequest.apiKey]
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try ApiRequest.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
        
    }
}

public enum SearchError: Error {
    case requestError(Error)
    case serializationError
}

public func fetchEntity<T: Codable>(from request: ApiRequest, successHandler: @escaping (T) -> Void, errorHandler: @escaping (SearchError) -> Void) {
    AF.request(request)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let resp = try Utilities.jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        successHandler(resp)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        errorHandler(SearchError.serializationError)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    errorHandler(SearchError.requestError(error))
                }
            }
        }
}
