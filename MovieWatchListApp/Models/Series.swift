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
    var runtime: [Int]?
    
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
        case runtime = "episode_run_time"
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
    var listOfSeries = [SeriesGroup(category: "Watching", isExpanded: true, series: []), SeriesGroup(category: "Watched", isExpanded: true, series: []), SeriesGroup(category: "Plan to watch", isExpanded: true, series: [])]
    
    mutating func remove(section: Int, row: Int) {
        listOfSeries[section].series.remove(at: row)
    }
    
    mutating func switchCategory(section: Int, row: Int, newCategory: String) -> (Int, Int){
        var newSection = section
        var newRow = row
        var removed = listOfSeries[section].series.remove(at: row)
        removed.category = newCategory
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
    mutating func updateSeason(section: Int, row: Int, newSeason: String) {
        listOfSeries[section].series[row].season = Int.init(newSeason) ?? 1
    }
    mutating func updateEpisode(section: Int, row: Int, newEpisode: String) {
        listOfSeries[section].series[row].episode = Int.init(newEpisode) ?? 1
    }
    mutating func removeAllSeries() {
        for i in 0...listOfSeries.count - 1 {
            listOfSeries[i].series.removeAll()
        }
    }
}
