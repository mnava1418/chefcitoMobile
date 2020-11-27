//
//  NewRecipeViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 26/11/20.
//

import UIKit

class NewRecipeViewController: UIViewController {

    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var pickerCategory: UIPickerView!
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var txtInstructions: UITextView!
    
    private let categories = ["Entrada", "Sopa", "Plato fuerte", "Postre"]
    private var ingredients:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerCategory.dataSource = self
        pickerCategory.delegate = self
        ingredientTable.dataSource = self
        ingredientTable.delegate = self
    }
    
    private func showNewIngredientForm() {
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
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        showNewIngredientForm()
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

// MARK: - Picker View
extension NewRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

// MARK: - Table View
extension NewRecipeViewController: UITableViewDataSource, UITableViewDelegate {
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
}
