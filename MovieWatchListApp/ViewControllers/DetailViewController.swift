import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        if let details = details {
            navigationBar.title = details.title
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
