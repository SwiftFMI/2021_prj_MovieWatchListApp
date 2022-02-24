import Foundation
import FirebaseFirestore
import Firebase

class UserService {
    var db = Firestore.firestore()
    let encoder = JSONEncoder()
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
                                    posterPath: movie.posterPath, myRating: 0, category: category,
                                    genresIDs: movie.genresIDs)
        
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
                                      season: series.seasons ?? 0,
                                      episode: series.nextEpisode?.episodeNumber ?? 0,
                                      category: category,
                                      genresIDs: series.genresIDs,
                                      nextAirDate: series.nextEpisode?.airDate ?? "")
        
        
        encoder.outputFormatting = . prettyPrinted
        let data = try! encoder.encode(seriesToAdd)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid)
                .updateData(["Series": FieldValue.arrayUnion([serialized])])
        }
    }
    
    func deleteMovie(movie: MovieShort) {
        
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(movie)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["Movies": FieldValue.arrayRemove([serialized])])
        }
    }
    
    func deleteSeries(series: SeriesShort) {
        
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(series)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["Series": FieldValue.arrayRemove([serialized])])
        }
    }
    
    func updateSeries(series:SeriesShort, category: Category,rating: Int,episode:Int,season: Int) {
        deleteSeries(series: series)
        
        var newSeries=series
        newSeries.myRating=rating
        newSeries.category=category.rawValue
        newSeries.episode = episode
        newSeries.season = season
        
        encoder.outputFormatting = . prettyPrinted
        let data = try! encoder.encode(newSeries)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid)
                .updateData(["Series": FieldValue.arrayUnion([serialized])])
        }
    }
    func updateMovie(movie:MovieShort, category: Category, rating: Int){
        deleteMovie(movie: movie)
        
        var newMovie=movie
        newMovie.myRating=rating
        newMovie.category=category.rawValue
        
        encoder.outputFormatting = . prettyPrinted
        let data = try! encoder.encode(newMovie)
        let serialized: String? = String(data: data,encoding: .utf8)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid)
                .updateData(["Movies": FieldValue.arrayUnion([serialized])])
        }
    }
    
    func getAllSeries(){
        var series: [SeriesShort] = []
        var rawSeries: [String] = []
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users")
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
            Firestore.firestore().collection("users")
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
