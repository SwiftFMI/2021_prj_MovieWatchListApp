import UIKit

class DiscoverViewController: UIViewController {
    var searchResult: MovieSearch?
    var movie:Movie?
    var movieSearch: MovieSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        
        let mockMovie = Movie(uid:UUID().uuidString ,movieId:219537,title: "Captain MMarvel", posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", summary:"The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.", language: "en",genresIDs:[28,12,878],rating: 6.9, releaseDate:"2019-03-06")
        
        //        MovieService.shared.getMovie(id: 27205)
        //        MovieService.shared.completionHandlerDetails { [weak self] (movie,status,message) in
        //                   if status {
        //                       guard let self = self else {return}
        //                       guard let _movie = movie else {return}
        //                       self.movie = _movie
        //                   }
        //               }
        
        //        movie = MovieService.shared.getMovie(id: 27205)
        MovieService.shared.setMovieDb(movie: mockMovie)
        
//        MovieService.shared.getMovieDb(movieId: mockMovie.movieId)
//        MovieService.shared.completionHandlerDetails {[weak self]
//            (movie,status,message) in
//            if status {
//                guard let self = self else {return}
//                guard let _movie = movie else {return}
//                self.movie = _movie
//                //reload
//                print(self.movie)
//            }
//        }
        
        //        MovieService.shared.searchMovie(query: "Am")
        //        MovieService.shared.completionHandlerSearch { [weak self] (movieSearch,status,message) in
        //            if status {
        //                guard let self = self else {return}
        //                guard let _movieSearch = movieSearch else {return}
        //                self.movieSearch = _movieSearch
        //            }
        //        }
        //    }
        
        
    }
}
