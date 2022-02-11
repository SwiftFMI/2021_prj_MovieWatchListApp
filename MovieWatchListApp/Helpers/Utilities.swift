//
//  Utilities.swift
//  MovieWatchListApp
//
//  Created by Admin on 10.02.22.
//

import Foundation


class Utilities {
    
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
    
}
