import Foundation
import Alamofire
import FirebaseFirestore
class SeriesService {
    
    private init() {}
    static let shared = SeriesService()
    
    let baseURL:String = "https://api.themoviedb.org/3"
    var apiKey = Utilities.getApiKey()
    
    typealias seriesSearchCallBack = (_ seriesSearch:SeriesSearch?, _ status: Bool, _ message:String) -> Void
    typealias seriesDetailsCallBack = (_ series:Series?, _ status: Bool, _ message:String) -> Void
    
    var seriesSearchCallBack: seriesSearchCallBack?
    var seriesDetailsCallBack: seriesDetailsCallBack?
    
    let headers:HTTPHeaders = [
        .accept("application/json"),
        .contentType("application/json")]
    
    func completionHandlerDetails(callBack: @escaping seriesDetailsCallBack) {
        self.seriesDetailsCallBack = callBack
    }
    
    func completionHandlerSearch(callBack: @escaping seriesSearchCallBack) {
        self.seriesSearchCallBack = callBack
    }
    
    func getSeries(id: Int) {
        let url:String = "\(baseURL)/tv/\(id)?api_key=\(apiKey)"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: Series.self) { response in
                guard let _ = response.data else {
                    self.seriesDetailsCallBack?(nil, false, "")
                    return}
                do {
                    let series = response.value
                    self.seriesDetailsCallBack?(series, true,"Success!")
                }
            }
        
    }
    
    func searchSeries(query: String) {
        var queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url:String = "\(baseURL)/search/tv?query=\(queryEncoded!)&api_key=\(apiKey)"
        AF.request(url,headers: headers)
            .responseDecodable(of: SeriesSearch.self) { response in
                guard let _ = response.data else {
                    self.seriesSearchCallBack?(nil, false, "")
                    return}
                do {
                    let seriesSearch = response.value
                    self.seriesSearchCallBack?(seriesSearch, true,"Success!")
                }
            }
    }
    
    func getSeriesDb(seriesId:Int) {
        let db = Firestore.firestore()
        db.collection("series")
            .whereField("id", isEqualTo: seriesId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error)
                } else if let snapshot = snapshot {
                    let _ = snapshot.documents.compactMap {
                        let seriesResult =  try? $0.data(as: Series.self)
                        self.seriesDetailsCallBack?(seriesResult, true,"Success!")
                    }
                }
            }
    }
    
    func setSeriesDb(series:Series) {
        let db = Firestore.firestore()
        db.collection("series")
            .whereField("id", isEqualTo: series.seriesId)
            .getDocuments() { (snapshot, error) in
                if snapshot?.count != 0  {
                    print("Already exists!")
                } else {
                    do {
                        try db.collection("series").document(series.uid!).setData(from: series)
                    } catch {
                        print(error)
                    }
                }
            }
    }
    
    func discoverByGennres(genresId: [Int],page: Int = 1) {
        let genresQuery: String = (genresId.map{String($0)}).joined(separator: ",")
        let url:String = "\(baseURL)/discover/tv?api_key=\(apiKey)&with_genres=\(genresQuery)&language=en-US&page=\(page)&sort_by=popularity.desc"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: SeriesSearch.self) { response in
                
                guard let _ = response.data else {
                    self.seriesSearchCallBack?(nil, false, "")
                    return}
                do {
                    let seriesSearch = response.value
                    self.seriesSearchCallBack?(seriesSearch, true,"Success!")
                }
            }
    }

    func popularSeries(page: Int = 1) {
        let url:String = "\(baseURL)/tv/popular?api_key=\(apiKey)&page=\(page)&sort_by=popularity.desc"
        
        AF.request(url,headers: headers)
            .responseDecodable(of: SeriesSearch.self) { response in
                
                guard let _ = response.data else {
                    self.seriesSearchCallBack?(nil, false, response.error?.localizedDescription ?? "")
                    return}
                do {
                    let seriesSearch = response.value
                    self.seriesSearchCallBack?(seriesSearch, true,"Success!")
                }
            }
    }
}
