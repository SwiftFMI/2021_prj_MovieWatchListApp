import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

enum Category: String,Codable {
    case watched
    case watching
    case planedToWatched = "planed to watch"
}
