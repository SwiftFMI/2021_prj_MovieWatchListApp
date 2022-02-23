import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Movie: Codable,Poster {
    @DocumentID var uid: String? = UUID().uuidString
    var movieId: Int
    var title: String
    var posterPath: String?
    var summary: String
    var language: String
    var genresIDs: [Int]?
    var genres: [Genre]?
    var rating: Double
    var releaseDate: String?
    var duration: Double?
    var myRaiting: Int?
    
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
        case duration = "runtime"
    }
    
    
}


struct MovieShort:Codable,Poster {
    var movieId: Int
    var title: String
    var posterPath: String?
    var myRating: Int
    var category: String?
    var genresIDs: [Int]?
}

struct Movies {
    var category: String
    var isExpanded: Bool
    var movies: [MovieShort]
}

struct TableMoviesModel {
//    var listOfMovies = [
//        Movies(category: "Watching", isExpanded: true, movies:
//                [MovieShort(movieId:299537,title: "Captain Marvel",
//                            posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg",myRating: 4, category: Category.watching.rawValue, genresIDs:[28,12,878]),
//
//                 MovieShort(movieId:258670,title: "Marvel Renaissance", posterPath:"/jRLAVahAT8wOJtp1c1NDeMDRXAo.jpg", myRating: 7,category: Category.watching.rawValue,genresIDs:[28,12,878]),
//
//                 MovieShort(movieId:622230,title: "LEGO Marvel Spider-Man: Vexed by Venom",
//                            posterPath:"/gTo2r8nNU3ZYAS6DqdeSp1VEqkq.jpg",myRating: 10, category: Category.watching.rawValue, genresIDs:[99,10770])]),
//
//        Movies(category: "Watched", isExpanded: true, movies: [MovieShort(movieId:299537,title: "Captain Marvel",  posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg",myRating: 7, category: Category.watched.rawValue, genresIDs:[28,12,878])])]
    var listOfMovies: [Movies] = [Movies(category: "Watching", isExpanded: true, movies: []), Movies(category: "Watched", isExpanded: true, movies: []), Movies(category: "Plan to watch", isExpanded: true, movies: [])]
    
    mutating func remove(section: Int, row: Int) {
        listOfMovies[section].movies.remove(at: row)
    }
    
    mutating func switchCategory(section: Int, row: Int, newCategory: String) -> (Int, Int){
        var newSection = section
        var newRow = row
        let removed = listOfMovies[section].movies.remove(at: row)
        let newCategoryIndex = listOfMovies.firstIndex { m in
            m.category == newCategory
        };
        if let categoryIndex = newCategoryIndex {
            listOfMovies[categoryIndex].movies.append(removed)
            newSection = categoryIndex
            newRow = listOfMovies[categoryIndex].movies.count - 1
        }
        else{
            listOfMovies.append(Movies(category: newCategory, isExpanded: true, movies: [removed]))
            newSection = listOfMovies.count - 1
            newRow = 0
        }
        
        return (newSection, newRow)
    }
    mutating func updateRaiting(section: Int, row: Int, newRaiting: String) {
        listOfMovies[section].movies[row].myRating = Int.init(newRaiting) ?? 0
    }
    
}
