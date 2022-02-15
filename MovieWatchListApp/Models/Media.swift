import Foundation

protocol Media {
    var posterPath: String? { get  set}
    var genres: [Genre] { get  set}
    var releaseDate: String? { get set }
    
}
extension Media {
    var posterURL: URL{
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres.first?.name ?? "n/a"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utilities.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Utilities.dateFormatter.string(from: date)
    }
}
