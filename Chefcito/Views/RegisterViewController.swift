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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewElements()
    }
    
    private func setViewElements () {
        btnCreateUser = ViewUIElements.setUIButton(button: btnCreateUser)
    }
    
    private func showAlert(title: String, message: String) {
        let messageScreen = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Ok", style: .default)
        
        messageScreen.addAction(continueAction)
        self.present(messageScreen, animated: true)
    }
    
    @IBAction func createUser(_ sender: Any) {
        let currentUser:UserModel = UserModel(email: inputEmail.text!, password: inputPassword.text!)
        let validationResult:UserModel.UserError = currentUser.validateUser()
        
        if validationResult == .valid {
            print(validationResult.rawValue)
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            showAlert(title: "Error!", message: validationResult.rawValue)
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
