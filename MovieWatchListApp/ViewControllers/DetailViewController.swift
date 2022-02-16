import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detailTitle: UILabel!
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        if let details = details {
            detailTitle.text = details.title
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
