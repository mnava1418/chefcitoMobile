//
//  ChefcitoViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 24/11/20.
//

import UIKit

class ChefcitoViewController: UIViewController {

    @IBOutlet weak var btnReceips: UIButton!
    @IBOutlet weak var btnMenus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewElements()
    }
    
    private func setViewElements() {
        btnReceips.setMainButton()
        btnMenus.setMainButton()
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

extension UIButton {
    func setMainButton() {
        let button = self
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 20
        button.imageView?.clipsToBounds = true
        button.layer.cornerRadius = 20
    }
}
