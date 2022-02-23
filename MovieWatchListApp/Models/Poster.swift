import Foundation

protocol Poster {
    var posterPath: String? { get  set }
}
extension Poster {
    var posterURL: URL{
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
}
