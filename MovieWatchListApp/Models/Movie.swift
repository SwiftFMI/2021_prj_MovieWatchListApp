import UIKit
import FirebaseFirestoreSwift

struct Movie: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var summary: String
    var posterPath: String
    var laguage: String
    var genres: [String]
    var voteAverage: Double
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
