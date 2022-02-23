import Foundation
import FirebaseFirestoreSwift

struct Series: Codable,Poster {
    @DocumentID var uid: String? = UUID().uuidString
    var seriesId: Int
    var name: String
    var posterPath: String?
    var summary: String
    var language: String
    var genresIDs: [Int]?
    var genres: [Genre]?
    var seasons: Int?
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
        case seasons = "number_of_seasons"
        case rating = "vote_average"
        case releaseDate = "first_air_date"
        case nextEpisode = "next_episode_to_air"
    }
}

struct SeriesShort: Codable,Poster {
    var seriesId: Int
    var name: String
    var myRating: Int
    var posterPath: String?
    var season: Int
    var episode: Int
    var category: String?
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


struct SeriesGroup {
    var category: String
    var isExpanded: Bool
    var series: [SeriesShort]
}

struct TableSeriesModel {
    var listOfSeries = [
        SeriesGroup(category: "Watching", isExpanded: true, series:
                [SeriesShort(seriesId:299537,name: "Captain Marvel", myRating: 4, posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", season: 3, episode: 4, category: Category.watching.rawValue, genresIDs:[28,12,878], nextAirDate: "Next episode after 3 days"),
                 
                 SeriesShort(seriesId:258670,name: "Marvel Renaissance", myRating: 7,posterPath:"/jRLAVahAT8wOJtp1c1NDeMDRXAo.jpg", season: 8, episode: 2, category: Category.watching.rawValue,genresIDs:[28,12,878], nextAirDate: "Next episode after 3 days"),
                 
                 SeriesShort(seriesId:622230,name: "LEGO Marvel Spider-Man: Vexed by Venom", myRating: 10,
                             posterPath:"/gTo2r8nNU3ZYAS6DqdeSp1VEqkq.jpg", season: 1, episode: 23, category: Category.watching.rawValue, genresIDs:[99,10770], nextAirDate: "Next episode after 3 days")]),
        
        SeriesGroup(category: "Watched", isExpanded: true, series: [SeriesShort(seriesId:299537,name: "Captain Marvel", myRating: 7, posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", season: 5, episode: 17, category: Category.watched.rawValue, genresIDs:[28,12,878], nextAirDate: "Next episode after 3 days")])]
    
    mutating func remove(section: Int, row: Int) {
        listOfSeries[section].series.remove(at: row)
    }
    
    mutating func switchCategory(section: Int, row: Int, newCategory: String) -> (Int, Int){
        var newSection = section
        var newRow = row
        let removed = listOfSeries[section].series.remove(at: row)
        let newCategoryIndex = listOfSeries.firstIndex { s in
            s.category == newCategory
        };
        if let categoryIndex = newCategoryIndex {
            listOfSeries[categoryIndex].series.append(removed)
            newSection = categoryIndex
            newRow = listOfSeries[categoryIndex].series.count - 1
        }
        else{
            listOfSeries.append(SeriesGroup(category: newCategory, isExpanded: true, series: [removed]))
        }
        
        return (newSection, newRow)
    }
    mutating func updateRaiting(section: Int, row: Int, newRaiting: String) {
        listOfSeries[section].series[row].myRating = Int.init(newRaiting) ?? 0
    }
    
}
