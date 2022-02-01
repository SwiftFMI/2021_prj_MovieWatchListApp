import UIKit

struct Movie {
    let title: String
    let posterImage: UIImage?
    let raiting: Int?
}

struct Movies {
    let category: String
    let movies: [Movie]
}

struct MockModel {
    let listOfMovies = [
        Movies( category: "Watched", movies: [Movie(title: "Iron Man", posterImage: UIImage(named: ""), raiting: 9)]),
        Movies( category: "Watching now", movies: [Movie(title: "Hulk", posterImage: UIImage(named: ""), raiting: 3)]),
        Movies( category: "Plan to watch", movies: [Movie(title: "Doctor Strange", posterImage: UIImage(named: ""), raiting: 7)])
    ]
}
