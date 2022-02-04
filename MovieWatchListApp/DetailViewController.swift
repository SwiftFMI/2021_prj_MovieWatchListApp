import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTitle: UILabel!
    var details: Details!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let details = details {
            detailTitle.text = details.title
        }
    }


}
