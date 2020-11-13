//
//  LoginViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 13/11/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFaceBookLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewElements()
    }
    
    private func setViewElements () {
        btnLogin = ViewUIElements.setUIButton(button: btnLogin)
        btnFaceBookLogin = ViewUIElements.setUIButton(button: btnFaceBookLogin)
        btnGoogleLogin = ViewUIElements.setUIButton(button: btnGoogleLogin)
    }
    
    @IBAction func recoverPassword(_ sender: Any) {
        print("Recover Password")
    }
    
    @IBAction func login(_ sender: Any) {
        print("Login")
    }
    
    @IBAction func faceBookLogin(_ sender: Any) {
        print("FaceBook Login")
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        print("Google Login")
    }
    
    @IBAction func register(_ sender: Any) {
        print("Register")
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
