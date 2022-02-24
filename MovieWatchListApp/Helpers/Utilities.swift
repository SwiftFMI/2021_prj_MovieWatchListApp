import Foundation
import UIKit


class Utilities {
    
    static func getApiKey() -> String {
        if let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: Any] {
            return dict["API_KEY"] as! String
        }
        return ""
    }
    static func imageUrl(path: String) -> String {
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    static func isPasswordValid(_ password: String) -> Bool {
        // Minimum eight characters, at least one letter, one number and one special character:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static func readLocalJSONFile(fileName file: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: file, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    static func readGenres(fileName file: String) -> [Genre] {
        do {
            let decodedData = try JSONDecoder().decode([Genre].self, from: Utilities.readLocalJSONFile(fileName: file) ?? Data())
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return [Genre]()
    }
   
    static func getGenreIdFromStringMovie(name: String) -> Int{
        let filtered = MovieGenres.movieGenres.first(where: {$0.name == name})
        return filtered?.id ?? 0
    }
    
    static func getGenreIdFromStringSeries(name: String) -> Int {
        let filtered = SeriesGenres.seriesGenres.first(where: {$0.name == name})
        return filtered?.id ?? 0
    }
    
    static func getFromatedDate(date:String?) -> String {
        if date == "" {
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date!)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = dateFormatter.string(from: date!)
        return resultString
    }
}

extension UIImageView {
    public func load(url: URL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
}
