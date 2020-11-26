//
//  LoginViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 13/11/20.
//

import UIKit
import AudioToolbox
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
   
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = Tokens.GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self

        // Do any additional setup after loading the view.
        setViewElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserModel.tokenExists() {
            self.performSegue(withIdentifier: "showMainAppLogin", sender: nil)
        }
    }
    
    private func showError(message: String) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        txtError.isHidden = false
        txtError.text = message
    }
    
    private func setViewElements () {
        txtError.isHidden = true
        btnLogin = ViewUIElements.setUIButton(button: btnLogin)
        
        inputEmail.delegate = self
        inputEmail.tag = 10
        
        inputPassword.delegate = self
        inputPassword.tag = 11
    }
    
    private func validateLoginResponse(status: Int, json: Dictionary<String, Any>) {
        self.activityIndicator.stopAnimating()
        
        switch status {
        case 200:
            UserModel.saveToken(token: json["token"] as! String)
            self.performSegue(withIdentifier: "showMainAppLogin", sender: nil)
        case 400:
            if let error = json["error"] {
                self.showError(message: error as! String)
            } else {
                self.showError(message: Constants.GENERIC_ERROR)
            }
        default:
            self.showError(message: Constants.GENERIC_ERROR)
        }
    }
    
    private func hideKeyBoard() {
        inputEmail.resignFirstResponder()
        inputPassword.resignFirstResponder()
    }
    
    @IBAction func recoverPassword(_ sender: Any) {
        print("Recover Password")
    }
    
    @IBAction func login(_ sender: Any) {
        hideKeyBoard()
        txtError.isHidden = true
        activityIndicator.startAnimating()
        
        let currentUser:UserModel = UserModel(email: inputEmail.text!, password: inputPassword.text!, isFacebook: false, isGoogle: false)
        let validationResult:UserModel.UserError = currentUser.validateUser()
        
        if validationResult == .valid {
            currentUser.login { (status, json) in
                self.validateLoginResponse(status: status, json: json)
            }
        } else {
            activityIndicator.stopAnimating()
            showError(message: validationResult.rawValue)
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        hideKeyBoard()
        txtError.isHidden = true
        activityIndicator.startAnimating()
        let faceBookService = FaceBookService()
        faceBookService.login(view: self) { (status, json) in
            self.validateLoginResponse(status: status, json: json)
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        hideKeyBoard()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func register(_ sender: Any) {
        self.performSegue(withIdentifier: "showRegisterView", sender: nil)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let googleService = GoogleService()
        googleService.login(user: user, error: error) { (status, json) in
            self.validateLoginResponse(status: status, json: json)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTag = textField.tag
        
        if currentTag == 10 {
            if let nextTextField = textField.superview?.viewWithTag(currentTag + 1 ) as? UITextField {
                nextTextField.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
