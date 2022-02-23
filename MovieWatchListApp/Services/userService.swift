import Foundation
import FirebaseFirestore
import Firebase

class UserService {
    var db = Firestore.firestore()
    private init() {}
    static let shared = UserService()
    
    func addMovieToWatched(movie: Movie) {
        let movieToAdd = MovieShort(movieId: movie.movieId,
                                    title: movie.title,
                                    myRating: 0,
                                    posterPath: movie.posterPath,
                                    category: Category.watched,
                                    genresIDs: movie.genresIDs)
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["watchedMovies": FieldValue.arrayUnion([movieToAdd])] )
        }
    }
    
    func deleteWatchedMovie(movie: Movie) {
        let movieToDelete = MovieShort(movieId: movie.movieId,
                                       title: movie.title,
                                       myRating: 0,
                                       posterPath: movie.posterPath,
                                       category: Category.watched,
                                       genresIDs: movie.genresIDs)
        
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["watchedMovies": FieldValue.arrayRemove([movieToDelete])])
        }
    }
    
    func addSeriesToWatched(series: Series) {
        let seriesToAdd = SeriesShort(seriesId: series.seriesId, name: series.name, myRating: series.rating, posterPath: series.posterPath, season: series.seasons, episode: series.nextEpisode?.episodeNumber ?? 0, category: Category.watched, genresIDs: series.genresIDs, nextAirDate: series.nextEpisode?.airDate ?? "")
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["watchedSeries": FieldValue.arrayUnion([seriesToAdd])]);
        }
    }
    
    func deleteWatchedSeries(series: Series) {
        let seriesToDelete = SeriesShort(seriesId: series.seriesId, name: series.name, myRating: series.rating, posterPath: series.posterPath, season: series.seasons, episode: series.nextEpisode?.episodeNumber ?? 0, category: Category.watched, genresIDs: series.genresIDs, nextAirDate: series.nextEpisode?.airDate ?? "")
        
     
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).updateData(["watchedSeries": FieldValue.arrayRemove([seriesToDelete])]);
        }
    }
    
}
