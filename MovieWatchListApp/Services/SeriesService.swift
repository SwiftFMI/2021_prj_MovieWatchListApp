import Foundation
import Alamofire

class SeriesService {
    
    let baseURL:String = "https://api.themoviedb.org/3"
    var apiKey = Utilities.getApiKey()
    
    static let shared = SeriesService()
    private init() {}
    
    func getSeries(id: Int) -> Series? {
        var series: Series? = nil
        let url:String = "\(baseURL)/tv/\(id)?api_key=\(apiKey)"
        let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
        
        AF.request(url,headers: headers)
            .responseDecodable(of: Series.self) { response in
                switch response.result {
                case .success:
                    series = response.value
                case .failure:
                    print(response.error?.localizedDescription ?? "")
                }
            }
        return  series ?? nil
    }
    
    func searchMovie(query: String) -> SeriesSearch? {
            var seriesSearchResult: SeriesSearch? = nil
            let url:String = "\(baseURL)/search/movie?query=\(query)&api_key=\(apiKey)"
            let headers:HTTPHeaders = ["Content-Type" : "application/json","Accept" : "application/json"]
            AF.request(url,headers: headers)
                .responseDecodable(of: SeriesSearch.self) { response in
                    switch response.result {
                    case .success:
                        seriesSearchResult = response.value
                        print(seriesSearchResult?.results[0].title)
                    case .failure:
                        print(response.error?.localizedDescription)
                    }
                }
            return  seriesSearchResult ?? nil
        }
    
}
