import Foundation
import FirebaseFirestoreSwift

struct Series: Codable,Media {
    @DocumentID var uid: String? = UUID().uuidString
    var seriesId: Int
    var name: String
    var posterPath: String?
    var summary: String
    var language: String
    var genresIDs: [Int]?
    var genres: [Genre]?
    var seasons: Int
    var rating: Double
    var releaseDate: String?
    var nextEpisode: NextEpisode?
    
    enum CodingKeys: String, CodingKey {
        case seriesId = "id"
        case name
        case posterPath = "poster_path"
        case summary = "overview"
        case language = "original_language"
        case genresIDs = "genre_ids"
        case genres
        case seasons = "number_of_episodes"
        case rating = "vote_average"
        case releaseDate = "first_air_date"
        case nextEpisode = "next_episode_to_air"
    }
}
struct SeriesShort: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var seriesId: Int
    var name: String
    var myRating: Double
    var posterPath: String?
    var season: Int
    var episode: Int
    var category: Category?
    var genresIDs: [Int]?
    var nextAirDate: String
}

struct NextEpisode: Codable {
    
    var airDate: String
    var episodeNumber: Int
    var id: Int
    var name: String
    var overview: String
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id
        case name
        case overview
    }
    
}
