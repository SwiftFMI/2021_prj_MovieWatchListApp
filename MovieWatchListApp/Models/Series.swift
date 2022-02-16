import Foundation
import FirebaseFirestoreSwift

struct Series: Identifiable, Codable,Media {
    @DocumentID var id: String? = UUID().uuidString
    var seriesId: Int
    var title: String
    var posterPath: String?
    var summary: String
    var language: String
    var genresIDs: [Int]
    var genres: [Genre]?
    var seasons: Int
    var rating: Double
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case seriesId = "id"
        case title = "name"
        case posterPath = "poster_path"
        case summary = "overview"
        case language = "original_language"
        case genresIDs = "genre_ids"
        case genres
        case seasons = "number_of_episodes"
        case rating = "vote_average"
        case releaseDate = "first_air_date"
    }
}
