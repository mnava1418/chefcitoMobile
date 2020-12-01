//
//  NewRecipeViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 26/11/20.
//

import UIKit

class NewRecipeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    
    private var primaryColor: UIColor!
    private var secondaryColor: UIColor!
    
    private let categories = ["Entrada", "Sopa", "Plato fuerte", "Postre"]
    private var ingredients:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        btnOne.tag = 1
        btnTwo.tag = 2
        btnThree.tag = 3
        
        primaryColor = btnOne.tintColor
        secondaryColor = btnTwo.tintColor
    }
    
    private func scrollToPage (page: Int) {
         var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    private func setIndicators (currentPage: Int) {
        pageControl.currentPage = currentPage - 1
        btnOne.setStatusColor(currentPage: currentPage, primaryColor: primaryColor, secondaryColor: secondaryColor)
        btnTwo.setStatusColor(currentPage: currentPage, primaryColor: primaryColor, secondaryColor: secondaryColor)
        btnThree.setStatusColor(currentPage: currentPage, primaryColor: primaryColor, secondaryColor: secondaryColor)
    }
    
    @IBAction func scrollToPageBtn(_ sender: Any) {
        let btn = sender as! UIButton
        scrollToPage(page: btn.tag - 1)
        setIndicators(currentPage: btn.tag)
    }
    
    
    /*private func showNewIngredientForm() {
        let addIngredientScreen = UIAlertController(title: "Ingrediente", message: "", preferredStyle: .alert)
        addIngredientScreen.addTextField { textField in
            textField.placeholder = "Ingrediente"
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            if let ingredient = addIngredientScreen.textFields?[0].text {
                self.ingredients.append(ingredient)
                self.ingredientTable.reloadData()
            }
        }
        
        addIngredientScreen.addAction(cancelAction)
        addIngredientScreen.addAction(okAction)
        
        self.present(addIngredientScreen, animated: true)
    }*/
    
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
    func setStatusColor(currentPage: Int, primaryColor: UIColor, secondaryColor: UIColor) {
        if self.tag == currentPage {
            self.tintColor = primaryColor
        } else {
            self.tintColor = secondaryColor
        }
    }
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}

extension NewRecipeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicators(currentPage: scrollView.currentPage)
    }
}

// MARK: - Picker View
/*extension NewRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}*/

// MARK: - Table View
/*extension NewRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, compretionHandler) in
            self.ingredients.remove(at: indexPath.row)
            self.ingredientTable.reloadData()
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = true
        return actions
    }
}*/
