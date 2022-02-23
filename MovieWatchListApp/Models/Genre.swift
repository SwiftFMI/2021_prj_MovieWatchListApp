import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

enum Category: String,Codable {
    case watched = "Watched"
    case watching = "Watching"
    case planedToWatched = "Plan to watch"
}
