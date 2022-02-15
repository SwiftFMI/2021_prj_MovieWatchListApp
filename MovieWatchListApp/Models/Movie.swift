import Foundation
import FirebaseFirestoreSwift

struct Movie: Identifiable, Codable,Media {
    @DocumentID var id: String? = UUID().uuidString
    var movieId: Int
    var title: String
    var summary: String
    var posterPath: String?
    var language: String
    var genres: [Genre]
    var rating: Double
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case summary = "overview"
        case posterPath = "poster_path"
        case genres
        case language = "original_language"
        case rating = "vote_average"
        case releaseDate = "release_date"
    }
//    var posterURL: URL {
//        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
//    }
//
//    var genreText: String {
//        genres.first?.name ?? "n/a"
//    }
//
//    var yearText: String {
//        guard let releaseDate = self.releaseDate, let date = Utilities.dateFormatter.date(from: releaseDate) else {
//            return "n/a"
//        }
//        return Utilities.dateFormatter.string(from: date)
//    }
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
