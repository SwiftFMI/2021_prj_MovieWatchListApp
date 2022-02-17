import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Movie: Identifiable,Codable,Media {
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
    var duration: Double?
    
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

struct Movies {
    let category: String
    var isExpanded: Bool
    var movies: [Movie]
}

struct MockModel {
    var listOfMovies = [Movies(category: "Watching", isExpanded: true, movies: [
        Movie(id:UUID().uuidString ,movieId:299537,title: "Captain Marvel", posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", summary:"The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.", language: "en",genresIDs:[28,12,878],rating: 6.9, releaseDate:"2019-03-06"),
        
        Movie(id:UUID().uuidString ,movieId:258670,title: "Marvel Renaissance",posterPath:"/jRLAVahAT8wOJtp1c1NDeMDRXAo.jpg", summary:"Documentary about the rise of Marvel Studios after their near-bankruptcy in the mid-1990s.",language: "fr",genresIDs:[28,12,878],rating: 5.6, releaseDate:"2014-02-28"),
        
        Movie(id:NSUUID().uuidString,movieId:622230,title: "LEGO Marvel Spider-Man: Vexed by Venom",
              posterPath:"/gTo2r8nNU3ZYAS6DqdeSp1VEqkq.jpg", summary:"Thanks to Green Goblin and Venom, tech theft is now at an all-time high. Can our Friendly Neighborhood Spider-Man put an end to their mysterious villainous scheme before all of New York City is destroyed?", language: "en", genresIDs:[99,10770],rating: 6.1, releaseDate:"2016-03-06")])]
    
}
