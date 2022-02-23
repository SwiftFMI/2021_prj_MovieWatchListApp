import Foundation
import FirebaseFirestore
import Firebase

class UserService {
    var db = Firestore.firestore()
    private init() {}
    static let shared = UserService()
    
    typealias moviesCallback = (_ movies:[MovieShort]?, _ status: Bool, _ message:String) -> Void
    typealias seriesCallback = (_ series:[SeriesShort]?, _ status: Bool, _ message:String) -> Void
    
    var moviesCallback: moviesCallback?
    var seriesCallback: seriesCallback?
    
    func completionHandlerMovies(callBack: @escaping moviesCallback) {
        self.moviesCallback = callBack
    }
    
    func completionHandlerSeries(callBack: @escaping seriesCallback) {
        self.seriesCallback = callBack
    }
    
    
    func addMovie(movie: Movie,category: String) {
        let movieToAdd = MovieShort(movieId: movie.movieId,
                                    title: movie.title,
                                    posterPath: movie.posterPath,
                                    myRating: 0,category: category)
        
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(movieToAdd)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid)
                .updateData(["Movies": FieldValue.arrayUnion([serialized])])
        }
    }
    
    func addSerie(series: Series,category: String) {
        let seriesToAdd = SeriesShort(seriesId: series.seriesId,
                                      name: series.name, myRating: 0,
                                      posterPath: series.posterPath,
                                      season: series.seasons,
                                      episode: series.nextEpisode?.episodeNumber ?? 0,
                                      category: category,
                                      genresIDs: series.genresIDs,
                                      nextAirDate: series.nextEpisode?.airDate ?? "")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(seriesToAdd)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid)
                .updateData(["Series": FieldValue.arrayUnion([serialized])])
        }
    }
    
    func deleteMovie(movie: Movie) {
        let movieToDelete = MovieShort(movieId: movie.movieId,
                                       title: movie.title,
                                       posterPath: movie.posterPath,
                                       myRating: 0,
                                       genresIDs: movie.genresIDs)
        
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["Movies": FieldValue.arrayRemove([movieToDelete])])
        }
    }
    func deleteSeries(series: Series) {
        let seriesToDelete = SeriesShort(seriesId: series.seriesId, name: series.name, myRating: 0, posterPath: series.posterPath, season: series.seasons, episode: series.nextEpisode?.episodeNumber ?? 0, category: "", genresIDs: series.genresIDs, nextAirDate: series.nextEpisode?.airDate ?? "")
        
        
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["watchedSeries": FieldValue.arrayRemove([seriesToDelete])]);
        }
    }
    
    func getAllSeries(){
        var series: [SeriesShort] = []
        var rawSeries: [String] = []
        if let user = Auth.auth().currentUser {
            let seriesRef = Firestore.firestore().collection("users")
                .document(user.uid).getDocument{ (document,error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    rawSeries = document?.get("Series") as! [String]
                    for raw in rawSeries {
                        let jsonData = Data(raw.utf8)
                        let decoder = JSONDecoder()
                        
                        do {
                            let ser = try decoder.decode(SeriesShort.self, from: jsonData)
                            series.append(ser)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    self.seriesCallback?(series,true,"Succes!")
                }
        }
    }
    
    func getAllMovies(){
        var movies: [MovieShort] = []
        var rawMovies: [String] = []
        if let user = Auth.auth().currentUser {
            let moviesRef = Firestore.firestore().collection("users")
                .document(user.uid).getDocument{ (document,error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    rawMovies = document?.get("Movies") as! [String]
                    for rawMovie in rawMovies {
                        let jsonData = Data(rawMovie.utf8)
                        let decoder = JSONDecoder()
                        
                        do {
                            let movie = try decoder.decode(MovieShort.self, from: jsonData)
                            movies.append(movie)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    self.moviesCallback?(movies,true,"Succes!")
                }
        }
    }
    
}
