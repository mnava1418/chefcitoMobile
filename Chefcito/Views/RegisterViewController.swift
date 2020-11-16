//
//  RegisterViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 13/11/20.
//

import UIKit
import AudioToolbox

class RegisterViewController: UIViewController {

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnCreateUser: UIButton!
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewElements()
    }
    
    private func setViewElements () {
        txtError.isHidden = true
        btnCreateUser = ViewUIElements.setUIButton(button: btnCreateUser)
    }
    
    private func showError(message: String) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        txtError.isHidden = false
        txtError.text = message
    }
    
    @IBAction func createUser(_ sender: Any) {
        txtError.isHidden = true
        activityIndicator.startAnimating()
        
        let currentUser:UserModel = UserModel(email: inputEmail.text!, password: inputPassword.text!)
        let validationResult:UserModel.UserError = currentUser.validateUser()
        
        if validationResult == .valid {
            currentUser.createUser { (status, json) in
                self.activityIndicator.stopAnimating()
                
                switch status {
                case 200:
                    print("Entramos!")
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
