import Foundation
import FirebaseFirestoreSwift

struct Series: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var summary: String
    var poster_path: String
    var laguage: String
    var genres: [String]
    var episodesPerSeason: Int
    var seasons: Int
}
