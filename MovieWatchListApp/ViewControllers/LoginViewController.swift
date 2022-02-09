
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        loginFormView.layer.cornerRadius = 30
        LoginButton.layer.cornerRadius = 30
        RegisterButton.layer.cornerRadius = 30
    }
}
