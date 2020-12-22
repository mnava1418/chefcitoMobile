//
//  ShowRecipesViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 18/12/20.
//

import UIKit

class ShowRecipesViewController: UIViewController {
           
    @IBOutlet weak var tableView: UITableView!
    
    var recipes:[RecipeModel]!
    var dataSource: UITableViewDiffableDataSource<Section, RecipeModel>! = nil
    var downloadedURLs:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "RecipeShowViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeShowCell")
        setDataSource()
        self.tableView.dataSource = self.dataSource
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, RecipeModel>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(self.recipes)
        self.dataSource.apply(initialSnapshot, animatingDifferences: true)
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, RecipeModel>(tableView: tableView) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
