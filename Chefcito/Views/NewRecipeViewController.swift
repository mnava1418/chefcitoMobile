//
//  NewRecipeViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 26/11/20.
//

import UIKit

enum ImagePickerType: String {
    case new = "Imagen nueva"
    case existent = "Imagen existente"
}

class NewRecipeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var alphaView: UIView!
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var pickerCategory: UIPickerView!
    @IBOutlet weak var btnNextOne: UIButton!
    
    @IBOutlet weak var tableIngredients: UITableView!
    @IBOutlet weak var btnNextTwo: UIButton!
    
    
    @IBOutlet weak var inputNum: UITextField!
    @IBOutlet weak var txtInstructions: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    private var primaryColor: UIColor!
    private var secondaryColor: UIColor!
    private var imagePicker: UIImagePickerController = UIImagePickerController()
    
    private let categories = ["Entrada", "Sopa", "Plato fuerte", "Postre"]
    private var ingredients:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        primaryColor = btnOne.tintColor
        secondaryColor = btnTwo.tintColor
        
        prepareViewElements()
    }
    
    private func prepareViewElements() {
        //Prepare data sources and delegates
        scrollView.delegate = self
        imagePicker.delegate = self
        pickerCategory.dataSource = self
        pickerCategory.delegate = self
        
        //Prepare buttons
        btnOne.tag = 1
        btnTwo.tag = 2
        btnThree.tag = 3
        
        btnNextOne = ViewUIElements.setUIButton(button: btnNextOne)
        btnNextOne.tag = 2
        
        btnNextTwo = ViewUIElements.setUIButton(button: btnNextTwo)
        btnNextTwo.tag = 3
        
        btnSave = ViewUIElements.setUIButton(button: btnSave)
        
        txtInstructions.layer.cornerRadius = 10
        tableIngredients.layer.cornerRadius = 10
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
    
    private func showImagePickerType () {
        let viewAlert = UIAlertController(title: "Selecciona una imagen", message: "", preferredStyle: .actionSheet)
        let newImageAction = UIAlertAction(title: ImagePickerType.new.rawValue, style: .default) { (action) in
            self.setRecipeImage(imagePickerType: .new)
        }
        let existentImageAction = UIAlertAction(title: ImagePickerType.existent.rawValue, style: .default) { (action) in
            self.setRecipeImage(imagePickerType: .existent)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive)
        
        viewAlert.addAction(newImageAction)
        viewAlert.addAction(existentImageAction)
        viewAlert.addAction(cancelAction)
        
        self.present(viewAlert, animated: true)
    }
    
    private func setRecipeImage (imagePickerType: ImagePickerType) {
        var sourceType: UIImagePickerController.SourceType!
        
        if imagePickerType == .new {
            sourceType = .camera
        } else {
            sourceType = .photoLibrary
        }
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            self.imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true)
        }
    }
    
    @IBAction func scrollToPageBtn(_ sender: Any) {
        let btn = sender as! UIButton
        scrollToPage(page: btn.tag - 1)
        setIndicators(currentPage: btn.tag)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        showImagePickerType()
    }
    
    @IBAction func addIngredient(_ sender: Any) {
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        print("Vamo a guardar")
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

// MARK: - UIScrollViewDelegate
extension NewRecipeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicators(currentPage: scrollView.currentPage)
    }
}

// Mark: - UIImagePickerControllerDelegate
extension NewRecipeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        imgRecipe.image = selectedImage
        alphaView.alpha = 0
        btnImage.setTitle("", for: .normal)
    }
}

// MARK: - Picker View
extension NewRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = categories[row]
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        return attributedText
    }
}

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
