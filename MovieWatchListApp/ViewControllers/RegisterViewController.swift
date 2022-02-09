import UIKit

class RegisterViewController : UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var registerFormView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        logo.layer.cornerRadius = logo.frame.height/2
        registerFormView.layer.cornerRadius = 30
        registerButton.layer.cornerRadius = 30
    }

    @IBAction func RegisterPressed(_ sender: Any) {
    }
}
