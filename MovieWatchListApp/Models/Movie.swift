import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Movie: Codable,Media {
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


struct MovieShort:Codable {
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
    var listOfMovies = [
        Movies(category: "Watching", isExpanded: true, movies:
                [MovieShort(id:UUID().uuidString ,movieId:299537,title: "Captain Marvel", myRating: 4, posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", category: Category.watching, genresIDs:[28,12,878]),
                 
                 MovieShort(id:UUID().uuidString ,movieId:258670,title: "Marvel Renaissance", myRating: 7,posterPath:"/jRLAVahAT8wOJtp1c1NDeMDRXAo.jpg", category: Category.watching,genresIDs:[28,12,878]),
                 
                 MovieShort(id:NSUUID().uuidString,movieId:622230,title: "LEGO Marvel Spider-Man: Vexed by Venom", myRating: 10,
                            posterPath:"/gTo2r8nNU3ZYAS6DqdeSp1VEqkq.jpg", category: Category.watching, genresIDs:[99,10770])]),
        
        Movies(category: "Watched", isExpanded: true, movies: [MovieShort(id:UUID().uuidString ,movieId:299537,title: "Captain Marvel", myRating: 7, posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", category: Category.watched, genresIDs:[28,12,878])])]
    
    mutating func remove(section: Int, row: Int) {
        listOfMovies[section].movies.remove(at: row)
    }
    
    mutating func switchCategory(section: Int, row: Int, newCategory: String){
        let removed = listOfMovies[section].movies.remove(at: row)
        let newCategoryIndex = listOfMovies.firstIndex { m in
            m.category == newCategory
        };
        if let categoryIndex = newCategoryIndex {
            listOfMovies[categoryIndex].movies.append(removed)
        }
        else{
            listOfMovies.append(Movies(category: newCategory, isExpanded: true, movies: [removed]))
        }
        
    }
    mutating func updateRaiting(section: Int, row: Int, newRaiting: String) {
        listOfMovies[section].movies[row].myRating = Int.init(newRaiting) ?? 0
    }
    
}
