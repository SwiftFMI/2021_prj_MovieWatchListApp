import UIKit

class LogoutModalViewController : UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.layer.cornerRadius = 30
        signOutButton.layer.cornerRadius = signOutButton.frame.height/2
    }
    @IBAction func closeModalView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false,forKey:"isLogged")
        defaults.removeObject(forKey: "uesrId")
        defaults.removeObject(forKey: "userEmail")
        performSegue(withIdentifier: "signOut", sender: nil)
    }
    @IBAction func CancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
