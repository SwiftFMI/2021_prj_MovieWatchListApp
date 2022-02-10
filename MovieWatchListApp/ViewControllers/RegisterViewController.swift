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

    
    func validateFields() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
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
        
        let error = validateFields()
        
        if error != nil {
            // There is an error
             showError(error!)
        } else {
          // create user
        }
//        performSegue(withIdentifier: "registerSuccess", sender: sender)
        dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message:String) {
        // errorLabel.text = message
        // errorLabel.alpha = 1
    }
}
