import Foundation
import UIKit


class Utilities {
    
    static func getApiKey() -> String {
        if let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: Any] {
            debugPrint(dict["API_KEY"])
            return dict["API_KEY"] as! String
        }
        return ""
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordMatch = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordMatch.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailMatch = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailMatch.evaluate(with: email)
    }
    
    static func isUsernameValid(_ username: String) -> Bool {
        let usernameRegex = "^[a-z0-9_.]{3,16}$"
        let usernameMatch = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernameMatch.evaluate(with: username)
    }
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}

extension UIImageView {
    public func load(urlString: String) {
        let url = URL(string: urlString)
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
}
