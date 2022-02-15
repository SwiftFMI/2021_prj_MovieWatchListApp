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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        logo.layer.cornerRadius = logo.frame.height/2
        registerFormView.layer.cornerRadius = 30
        registerButton.layer.cornerRadius = 30
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
        } else {
            // create user
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in:
                                                                                    .whitespacesAndNewlines)
            let cleanedEmail = emailTextField.text!.trimmingCharacters(in:
                                                                            .whitespacesAndNewlines)
            let cleanedUsername = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { authResult, error in
                if error != nil {
                    // error?.localizedDescription //error description message
                    self.showError("Error creating user")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username":cleanedUsername, "uid": authResult!.user.uid, "watchedMovies":[], "watchedSeries":[]]) {(error) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                }
            }
        }
        activityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message:String) {
        validationMessage.text = message
    }
}
