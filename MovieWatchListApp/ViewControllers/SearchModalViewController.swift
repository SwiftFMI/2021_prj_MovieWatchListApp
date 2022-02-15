import UIKit

class SearchModalViewController : UIViewController {
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var applySearchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalViewContainer.layer.cornerRadius = 30
        applySearchButton.layer.cornerRadius = applySearchButton.frame.height/2
    }

    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ApplyFilters(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

