import Foundation

protocol SearchResult: Codable {
    var page: Int {get set}
    var totalPages : Int {get set}
    var totalResults: Int {get set}
}

struct MovieSearch: SearchResult {
    var page: Int
    var results: [Movie]
    var totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SeriesSearch: SearchResult {
    var page: Int
    var results: [Serie]
    var totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
