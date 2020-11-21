//
//  GoogleService.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 20/11/20.
//

import Foundation
import GoogleSignIn

struct GoogleService {
    public func login(user: GIDGoogleUser?, error: Error?, completion: @escaping (Int, Dictionary<String, Any>) -> Void) {
        if let loginError = error {
            let json = ["error": loginError.localizedDescription]
            completion(400, json)
        } else if let loginUser = user {
            let currentUser = UserModel(email: loginUser.profile.email, password: Tokens.SM_TOKEN, isFacebook: false, isGoogle: true)
            currentUser.socialMediaRegister { (status, json) in
                completion(status, json)
            }
        } else {
            let json = ["error": Constants.GENERIC_ERROR]
            completion(500, json)
        }
    }
}
