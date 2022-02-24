import UIKit
import Firebase
import FirebaseFirestore
class LoginViewController : UIViewController {
    var db = Firestore.firestore()
    @IBOutlet weak var loginFormView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        loginFormView.layer.cornerRadius = 30
        LoginButton.layer.cornerRadius = 15
        LoginButton.layer.masksToBounds = true
        RegisterButton.layer.cornerRadius = 15
        RegisterButton.layer.masksToBounds = true
        logo.layer.cornerRadius = logo.frame.height/2
    }
    
    func validateFields() -> String? {
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        //Valid Password
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPassword) {
            return "Wrong password format"
        }
        
        // Valid Email
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
        if !Utilities.isEmailValid(cleanedEmail) {
            return "Invalid email"
        }
        
        return nil
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        let error = validateFields()
        if error != nil {
            showError(error!)
            activityIndicator.stopAnimating()
        }else{
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let cleanedEmail = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { authResult, error in
                if error != nil{
                    self.showError(error!.localizedDescription)
                } else {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let defaults = UserDefaults.standard
                        defaults.set(true,forKey:"isLogged")
                        defaults.set(user.uid,forKey:"userId")
                        defaults.set(user.email,forKey: "userEmail")
                        self.performSegue(withIdentifier: "login", sender: sender)
                        self.activityIndicator.stopAnimating()
                    }
                }
                
            }
            
        }
        
    }
    
    @IBAction func RegisterPressed(_ sender: Any) {
        performSegue(withIdentifier: "openRegister", sender: sender)
    }
    
    func showError(_ message:String) {
        validationMessage.text = message
        validationMessage.alpha = 1
        activityIndicator.stopAnimating()
    }
}
