//
//  ChefcitoItemsViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 25/11/20.
//

import UIKit


enum RecipeCategories: String {
    case entradas = "Entradas"
    case sopas = "Sopas"
    case platos = "Platos Fuertes"
    case postres = "Postres"
}

class ChefcitoItemsViewController: UIViewController {
    
    @IBOutlet weak var entradastCollectionView: UICollectionView!
    @IBOutlet weak var viewEntradas: UIView!
    
    @IBOutlet weak var viewSopas: UIView!
    @IBOutlet weak var sopasCollectionView: UICollectionView!
    
    @IBOutlet weak var viewPlato: UIView!
    @IBOutlet weak var platoCollectionView: UICollectionView!
    
    @IBOutlet weak var viewPostres: UIView!
    @IBOutlet weak var postresCollectionView: UICollectionView!
    
    let limit = 5
    var recipesByCategory:[String: Array<RecipeModel>] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        let collectionViews:[UICollectionView] = [entradastCollectionView, sopasCollectionView, platoCollectionView, postresCollectionView]
        prepareCollectionViews(collectionViews: collectionViews)
        getCurrentRecipes()
    }
    
    private func prepareCollectionViews(collectionViews:[UICollectionView]) {
        var tag = 0
        for item in collectionViews {
            item.dataSource = self
            item.delegate = self
            item.tag = tag
            item.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
            tag += 1
        }
    }
    
    private func setNavBar() {
        let plusCircleImg = UIImage(systemName: "plus")
        let addButton = UIBarButtonItem(image: plusCircleImg, style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func showMessage() {
        let alert = UIAlertController(title: "Error", message: Constants.GENERIC_ERROR, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    private func getCurrentRecipes() {
        RecipeModel.getRecipesByCategory { (status, json) in
            if status == 200 {
                self.recipesByCategory.removeAll()
                if let recipesCategory = json["recipes"] as? Dictionary<String, Any> {
                    for (category, recipes) in recipesCategory  {
                        if self.recipesByCategory[category] == nil {
                            self.recipesByCategory[category] = []
                        }
                        
                        for recipe in recipes as! [Dictionary<String, Any>]{
                            let urlStr = "\(Constants.HOST)/recipes/\(recipe["fileName"] as! String)"
                            var recipeImage: UIImage? = nil
                            
                            if let encodedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                                let url = URL(string: encodedUrl)
                            
                                do {
                                    let data = try Data(contentsOf: url!)
                                    recipeImage = UIImage(data: data)
                                } catch {
                                    self.showMessage()
                                }
                            } else {
                                self.showMessage()
                            }
                            
                            let currentRecipe = RecipeModel(name: recipe["name"] as! String, category: category, ingredients: recipe["ingredients"] as! [String], instructions: recipe["instructions"] as! String, count: recipe["count"] as! Int, image: recipeImage)
                        
                            self.recipesByCategory[category]!.append(currentRecipe)
                        }
                     }
                }
                self.reloadCollectionViews()
            } else {
                self.showMessage()
            }
        }
    }
    
    public func reloadCollectionViews() {
        let collectionViews:[UICollectionView] = [self.entradastCollectionView, self.sopasCollectionView, self.platoCollectionView, self.postresCollectionView]
        for item in collectionViews {
            item.reloadData()
        }
    }
    
    private func getCollectionViewInfo(id: Int) -> Dictionary<String, Any> {
        var result:[String:Any] = [:]
        
        switch id {
        case 0:
            result["category"] = RecipeModel.RecipeCategories.entrada.rawValue
            result["currentView"] = self.viewEntradas
            break
        case 1:
            result["category"] = RecipeModel.RecipeCategories.sopa.rawValue
            result["currentView"] = self.viewSopas
            break
        case 2:
            result["category"] = RecipeModel.RecipeCategories.plato.rawValue
            result["currentView"] = self.viewPlato
            break
        case 3:
            result["category"] = RecipeModel.RecipeCategories.postre.rawValue
            result["currentView"] = self.viewPostres
            break
        default:
            break
        }
        
        return result
    }
  
    @objc private func addItem() {
        performSegue(withIdentifier: "createRecipe", sender: nil)
    }
       
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NewRecipeViewController
        destination.originalVC = self
    }
}

// MARK: - UICollectionViewDataSource
extension ChefcitoItemsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = collectionView.tag
        let info = self.getCollectionViewInfo(id: tag)
        
        if let category = info["category"] as? String, let currentView = info["currentView"] as? UIView {
            if let recipes = self.recipesByCategory[category] {
                currentView.isHidden = false
                if recipes.count > self.limit {
                    return self.limit
                } else {
                    return recipes.count
                }
            } else {
                currentView.isHidden = true
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag = collectionView.tag
        let info = self.getCollectionViewInfo(id: tag)
        let category = info["category"] as! String
        let recipe = self.recipesByCategory[category]![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeMainCell", for: indexPath) as! RecipeMainViewCell
        cell.name.text = recipe.getName()
        
        if let recipeImage = recipe.getImage() {
            cell.image.image = recipeImage
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 280, height: 168)
        return size
    }
}
