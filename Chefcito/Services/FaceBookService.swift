//
//  FaceBookService.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 18/11/20.
//

import Foundation
import FacebookLogin

struct FaceBookService {
    
    private enum FaceBookServiceError: Error {
        case invalidToken
    }
    
    private func getUserProfile (completion: @escaping (Error?, Any?) -> Void) {
        if let accessToken = FBSDKLoginKit.AccessToken.current {
            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email"], tokenString: accessToken.tokenString, version: nil, httpMethod: .get)
            graphRequest.start { (connection, result, error) in
                completion(error, result)
            }
        } else {
            completion(FaceBookServiceError.invalidToken, nil)
        }
    }
    
    public func login (view:LoginViewController, completion: @escaping (Int, Dictionary<String, Any>) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: view) { (result) in
            switch result {
            case .cancelled:
                completion(400, ["error": "Has cancelado el inicio de sesión."])
            case .failed(_):
                completion(500, ["error": Constants.GENERIC_ERROR])
            case .success(_,_,_):
                getUserProfile { (error, result) in
                    if error != nil {
                        completion(500, ["error": Constants.GENERIC_ERROR])
                    }
                    
                    if let userInfo = result as? Dictionary<String, Any> {
                        var user = UserModel(email: userInfo["email"] as! String, password: Constants.SM_TOKEN)
                        user.setIsFacebook(isFacebook: true)
                        user.socialMediaRegister { (status, json) in
                            completion(status, json)
                        }
                    }
                }
            }
        }
    }
}
