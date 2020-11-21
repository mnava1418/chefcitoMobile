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
    }
    
    private func validateLoginResponse(currentUser: UserModel, status: Int, json: Dictionary<String, Any>) {
        self.activityIndicator.stopAnimating()
        
        switch status {
        case 200:
            currentUser.saveToken(token: json["token"] as! String)
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
    
    @IBAction func recoverPassword(_ sender: Any) {
        print("Recover Password")
    }
    
    @IBAction func login(_ sender: Any) {
        txtError.isHidden = true
        activityIndicator.startAnimating()
        
        let currentUser:UserModel = UserModel(email: inputEmail.text!, password: inputPassword.text!)
        let validationResult:UserModel.UserError = currentUser.validateUser()
        
        if validationResult == .valid {
            currentUser.login { (status, json) in
                self.validateLoginResponse(currentUser: currentUser, status: status, json: json)
            }
        } else {
            activityIndicator.stopAnimating()
            showError(message: validationResult.rawValue)
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        txtError.isHidden = true
        activityIndicator.startAnimating()
        let faceBookService = FaceBookService()
        let currentUser = UserModel(email: "", password: "")
        faceBookService.login(view: self) { (status, json) in
            self.validateLoginResponse(currentUser: currentUser, status: status, json: json)
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func register(_ sender: Any) {
        self.performSegue(withIdentifier: "showRegisterView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        print(user)
    }
}
