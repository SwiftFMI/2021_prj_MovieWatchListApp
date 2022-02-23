import Foundation

protocol SearchResult: Codable {
    var page: Int {get set}
    var totalPages : Int {get set}
    var totalResults: Int {get set}
}

struct MovieSearch: SearchResult {
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SeriesSearch: SearchResult {
    var page: Int
    var results: [Series]
    var totalPages: Int
    var totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
