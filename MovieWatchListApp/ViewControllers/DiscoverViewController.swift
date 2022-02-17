import UIKit

class DiscoverViewController: UIViewController {
    var searchResult: MovieSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        let movie = MovieService.shared.getMovie(id: 27205)
        searchResult = MovieService.shared.searchMovie(query: "Am")
        print(searchResult?.results[0].title)
        let image = MovieService.shared.getImage(posterPath: searchResult?.results[0].posterPath ?? "")
    }


}
