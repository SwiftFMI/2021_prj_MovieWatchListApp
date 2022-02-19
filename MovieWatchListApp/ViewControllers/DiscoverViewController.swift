import UIKit

class DiscoverViewController: UIViewController {
    var searchResult: MovieSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        let movie = MovieService.shared.getMovie(id: 27205)
        if let movie = movie {
            MovieService.shared.setMovieDb(movie: movie)
        }
        searchResult = MovieService.shared.searchMovie(query: "Am")
        print(searchResult?.results[0].title)
    }


}
