import UIKit
import Firebase
import FirebaseFirestore
class RegisterViewController : UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var registerFormView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        logo.layer.cornerRadius = logo.frame.height/2
        registerFormView.layer.cornerRadius = 30
        registerButton.layer.cornerRadius = 15
        registerButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = backButton.frame.height/2
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        //Valid Username
        let cleanedUsername = usernameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if !Utilities.isUsernameValid(cleanedUsername) {
            return "Wrong username format"
        }
        
        //Valid Password
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:
                                                                                .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanedPassword) {
            return "Wrong password format"
        }
        
        // Valid Email
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in:
                                                                        .whitespacesAndNewlines)
        
        if !Utilities.isEmailValid(cleanedEmail) {
            return "Invalid email"
        }
        
        // Confirmed Password
        let cleanedConfirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in:
                                                                                            .whitespacesAndNewlines)
        
        if cleanedPassword != cleanedConfirmPassword {
            return "Passwords do not match"
        }
        
        return nil
    }
    
    @IBAction func RegisterPressed(_ sender: Any) {
        
        activityIndicator.startAnimating()
        let error = validateFields()
        if error != nil {
            // There is an error
            showError(error!)
            activityIndicator.stopAnimating()
        } else {
            // create user
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let cleanedEmail = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let cleanedUsername = usernameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { authResult, error in
                if error != nil {
                    self.showError(error!.localizedDescription)
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData([
                        "username":cleanedUsername,
                        "email":cleanedEmail,
                        "uid":authResult!.user.uid,
                        "registeredAt":Date(),
                        "Movies":[],
                        "Series":[]
                    ]) {(error) in
                        if error != nil {
                            self.showError(error!.localizedDescription)
                        }else{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func showError(_ message:String) {
        validationMessage.text = message
        validationMessage.alpha = 1
        activityIndicator.stopAnimating()
    }
}
