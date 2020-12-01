//
//  ChefcitoItemsViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 25/11/20.
//

import UIKit

class ChefcitoItemsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
    }
    
    private func setNavBar() {
        let plusCircleImg = UIImage(systemName: "plus")
        let addButton = UIBarButtonItem(image: plusCircleImg, style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addButton
    }
  
    @objc private func addItem() {
        performSegue(withIdentifier: "createRecipe", sender: nil)
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
