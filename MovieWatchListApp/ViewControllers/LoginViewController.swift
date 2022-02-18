import UIKit
import Firebase
import FirebaseFirestore
class LoginViewController : UIViewController {
    
    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        loginFormView.layer.cornerRadius = 30
        LoginButton.layer.cornerRadius = 30
        RegisterButton.layer.cornerRadius = 30
        logo.layer.cornerRadius = logo.frame.height/2
    }
    @IBAction func LoginPressed(_ sender: Any) {
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let cleanedEmail = usernameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { [weak self]  authResult, error in
            if error != nil{
                debugPrint(error)
            } else{
                    self?.performSegue(withIdentifier: "login", sender: sender)
            }

        }
    }
    @IBAction func RegisterPressed(_ sender: Any) {
        performSegue(withIdentifier: "openRegister", sender: sender)
    }
}
