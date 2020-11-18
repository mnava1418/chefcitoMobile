//
//  LoginViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 13/11/20.
//

import UIKit
import AudioToolbox

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFaceBookLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        btnFaceBookLogin = ViewUIElements.setUIButton(button: btnFaceBookLogin)
        btnGoogleLogin = ViewUIElements.setUIButton(button: btnGoogleLogin)
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
        } else {
            activityIndicator.stopAnimating()
            showError(message: validationResult.rawValue)
        }
    }
    
    @IBAction func faceBookLogin(_ sender: Any) {
        print("FaceBook Login")
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        print("Google Login")
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
