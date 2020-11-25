//
//  UserModel.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 13/11/20.
//

import Foundation
import Alamofire

struct UserModel {
    private let email:String!
    private let password:String!
    private var isFacebook:Bool!
    private var isGoogle:Bool!
    private var headers:HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    
    public enum UserError: String {
        case valid = "Usuario válido."
        case mandatory = "Todos los campos son obligatorios."
        case email = "Email no válido."
        case password = "Password no válido (8 caracteres, 1 mayúscula y 1 número)."
    }
    
    init(email: String, password: String, isFacebook: Bool, isGoogle: Bool) {
        self.email = email.trimmingCharacters(in: .whitespaces)
        self.password = password.trimmingCharacters(in: .whitespaces)
        self.isFacebook = isFacebook
        self.isGoogle = isGoogle
    }
    
    
    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = validateEmail.evaluate(with: email)
        return isValid
    }
    
    private func isValidPassword() -> Bool {
       //Minimum 8 characters at least 1 Alphabet and 1 Number:
       let passRegEx = "^(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,}$"
       let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
       let isValid = validatePassord.evaluate(with: password)
       return isValid
    }
  
    public func validateUser() -> UserError {
        
        if email == "" || password == "" {
            return UserError.mandatory
        }
        
        if !isValidEmail() {
            return UserError.email
        }
        
        if !isValidPassword() {
            return UserError.password
        }
            
        return UserError.valid
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func createUser(completion: @escaping (Int, Dictionary<String,Any>) -> Void) {
        let body:[String: String] = ["email": email, "password": password]
        NetWorkService.httpRequest(url: "/user/create", method: .post, parameters: body, headers: headers) {
            (status, json) in
            completion(status, json)
        }
    }
    
    public func login(completion: @escaping (Int, Dictionary<String,Any>) -> Void) {
        let body:[String: String] = ["email": email, "password": password]
        NetWorkService.httpRequest(url: "/user/login", method: .post, parameters: body, headers: headers) { (status, json) in
            completion(status, json)
        }
    }
    
    public mutating func socialMediaRegister(token:String, completion: @escaping (Int, Dictionary<String, Any>) -> Void) {
        headers["SMToken"] = token
        
        let body:[String: String] = ["email": email, "password": password, "isFaceBook": isFacebook.description, "isGoogle": isGoogle.description]
        NetWorkService.httpRequest(url: "/user/socialMedia", method: .post, parameters: body, headers: headers) { (status, json) in
            completion(status, json)
        }
    }
    
    
    public static func saveToken(token: String) {
        let key = Constants.TOKEN_KEY
        UserDefaults.standard.set(token, forKey: key)
    }
    
    public static func tokenExists() -> Bool {
        let key = Constants.TOKEN_KEY
        if UserDefaults.standard.string(forKey: key) != nil{
            return true
        }
        
        return false
    }
}
