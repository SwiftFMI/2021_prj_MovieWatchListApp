import UIKit

struct Movie {
    let title: String
    let posterImage: UIImage?
    let raiting: Int?
}

struct Movies {
    let category: String
    var isExpanded: Bool
    var movies: [Movie]
}

struct MockModel {
    var listOfMovies = [
        Movies( category: "Watched", isExpanded: true, movies: [Movie(title: "Iron Man", posterImage: UIImage(named: ""), raiting: 9)]),
        Movies( category: "Watching now", isExpanded: true, movies: [Movie(title: "Hulk", posterImage: UIImage(named: ""), raiting: 3)]),
        Movies( category: "Plan to watch", isExpanded: true, movies: [Movie(title: "Doctor Strange", posterImage: UIImage(named: ""), raiting: 7), Movie(title: "Moon Night", posterImage: UIImage(named: ""), raiting: -1)])
    ]
}
