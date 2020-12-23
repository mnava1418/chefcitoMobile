//
//  ShowRecipesViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 18/12/20.
//

import UIKit

class RecipeDataSource: UITableViewDiffableDataSource<Section, RecipeModel> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class ShowRecipesViewController: UIViewController {
           
    @IBOutlet weak var tableView: UITableView!
    
    var recipes:[RecipeModel]!
    var dataSource: RecipeDataSource! = nil
    var downloadedURLs:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "RecipeShowViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeShowCell")
        setDataSource()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, RecipeModel>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(self.recipes)
        self.dataSource.apply(initialSnapshot, animatingDifferences: true)
    }
    
    private func setDataSource() {
        dataSource = RecipeDataSource(tableView: tableView) {
         (tableView: UITableView, indexPath: IndexPath, recipe: RecipeModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeShowCell", for: indexPath) as! RecipeShowViewCellTableViewCell
            cell.name.text = recipe.getName()
            
            if let recipeImage = recipe.getImage() {
                cell.recipeImage.image = recipeImage
                return cell
            } else if recipe.getImageURL() != nil && self.downloadedURLs[recipe.getImageURL()!.absoluteString] == nil{
                cell.recipeImage.image = UIImage(named: "receta")
                
                Utils.loadImage(url: recipe.getImageURL()!) { image in
                    var updateSnapshot = self.dataSource.snapshot()
                    recipe.setImage(image: image)
                    self.recipes[indexPath.row] = recipe
                    self.downloadedURLs[recipe.getImageURL()!.absoluteString] = recipe.getImageURL()!.absoluteString
                    updateSnapshot.reloadItems([recipe])
                    self.dataSource.apply(updateSnapshot, animatingDifferences: true)
                    recipe.cleanImageFile()
                }
            }
        
            return cell
        }
    }
    
    private func deleteRecipe(indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.row]
        print(recipe)
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
// MARK: - UITableViewDelegate
extension ShowRecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, compretionHandler) in
            self.deleteRecipe(indexPath: indexPath)
        }
     
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
         
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = true
        return actions
    }
}
