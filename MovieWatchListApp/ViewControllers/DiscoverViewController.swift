import UIKit

class DiscoverViewController: UIViewController {
    var searchResult: MovieSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        searchResult = MovieService.shared.searchMovie(query: "Am")
        print(searchResult?.results[0].title)
    }


}
