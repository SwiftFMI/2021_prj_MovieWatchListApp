import Foundation
import Alamofire

//static func fetchAlbumWithAsyncURLSession() async throws -> [Album] {
//    guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=album") else {
//        throw AlbumsFetcherError.invalidURL
//    }
//
//    // Използваме async варианта на функциите от URLSession, за да вземем данните
//    // Функцията може да блокира изпълнението си тук
//    let (data, _) = try await URLSession.shared.data(from: url)
//
//    // Десериализираме JSON данните към обекти от нашите типове (хвърля се грешка при невъзможна сериализация поради невалидни данни)
//    let iTunesResult = try JSONDecoder().decode(ITunesResult.self, from: data)
//    // Връщаме резултата
//    return iTunesResult.results
//}
