import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var myRaitingButton: UIButton!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieLength: UILabel!
    @IBOutlet weak var movieRaiting: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var detailsViewContainer: UIView!
    @IBOutlet weak var scrollingView: UIScrollView!
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryButton.layer.cornerRadius = 25
        myRaitingButton.layer.cornerRadius = 25
        self.view.addBackground()
//        scrollingView.addBackground()
        detailsViewContainer.addBackground()
        if let details = details {
            navigationBar.title = details.title
            movieTitle.text = details.title
            movieGenres.text = details.genre.joined(separator: ", ")
            movieReleaseDate.text = details.releaseDate
            movieLength.text = details.length.description
            movieRaiting.text = details.raiting.description
            movieSummary.text = details.summary
        }
    }
}

class SerieDetailViewController: UIViewController {
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
//        if let details = details {
//            detailTitle.text = details.title
//        }
    }
}
