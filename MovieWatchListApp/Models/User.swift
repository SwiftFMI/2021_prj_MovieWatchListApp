import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var username: String
    var email: String
    var watchedMovies: [MovieShort]?
    var watchedSeries: [SeriesShort]?
}
