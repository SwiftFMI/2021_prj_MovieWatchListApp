import Foundation
import FirebaseFirestoreSwift

struct Movie: Identifiable, Codable,Media {
    @DocumentID var id: String? = UUID().uuidString
    var movieId: Int
    var title: String
    var posterPath: String?
    var summary: String
    var language: String
    var genresIDs: [Int]
    var genres: [Genre]?
    var rating: Double
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case posterPath = "poster_path"
        case summary = "overview"
        case language = "original_language"
        case genresIDs = "genre_ids"
        case genres
        case rating = "vote_average"
        case releaseDate = "release_date"
    }
}

struct Movies {
    let category: String
    var isExpanded: Bool
    var movies: [Movie]
}

struct MockModel {
    var listOfMovies = [Movies]()
    //    var listOfMovies = [
    //        Movies( category: "Watched", isExpanded: true, movies: [Movie(title: "Iron Man", posterImage: UIImage(named: ""), raiting: 9)]),
    //        Movies( category: "Watching now", isExpanded: true, movies: [Movie(title: "Hulk", posterImage: UIImage(named: ""), raiting: 3)]),
    //        Movies( category: "Plan to watch", isExpanded: true, movies: [Movie(title: "Doctor Strange", posterImage: UIImage(named: ""), raiting: 7), Movie(title: "Moon Night", posterImage: UIImage(named: ""), raiting: -1)])
    //    ]
}
