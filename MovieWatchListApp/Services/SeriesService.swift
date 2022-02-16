import Foundation

class SeriesService {
    
    static let shared = SeriesService()
    private init() {}
    
    func serachSeries(id: Int, successHandler: @escaping (Series) -> Void, errorHandler: @escaping (SearchError) -> Void) {
        fetchEntity(from: ApiRequest.fetchSeriesByID(id), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func searchSeries(query: String, successHandler: @escaping (MovieSearch) -> Void, errorHandler: @escaping (SearchError) -> Void) {
        fetchEntity(from: ApiRequest.searchSeriesByText(query), successHandler: successHandler, errorHandler: errorHandler)
    }
}
