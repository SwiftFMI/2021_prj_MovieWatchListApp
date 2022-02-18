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
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryButton.layer.cornerRadius = 25
        myRaitingButton.layer.cornerRadius = 25
        self.view.addBackground()
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
    @IBAction func CategoryButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "openPicker", sender: nil)
    }
}

class SerieDetailViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var serieImage: UIImageView!
    @IBOutlet weak var serieTitle: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var myRaitingButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var serieGenres: UILabel!
    @IBOutlet weak var serieReleaseDate: UILabel!
    @IBOutlet weak var serieLength: UILabel!
    @IBOutlet weak var serieRaiting: UILabel!
    @IBOutlet weak var serieSummary: UILabel!
    @IBOutlet weak var detailsViewContainer: UIView!
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        detailsViewContainer.addBackground()
        categoryButton.layer.cornerRadius = 25
        myRaitingButton.layer.cornerRadius = 25
        progressButton.layer.cornerRadius = 25
        if let details = details {
            navigationBar.title = details.title
            serieTitle.text = details.title
            serieGenres.text = details.genre.joined(separator: ", ")
            serieReleaseDate.text = details.releaseDate
            serieLength.text = details.length.description
            serieRaiting.text = details.raiting.description
            serieSummary.text = details.summary
    }
    }
}
