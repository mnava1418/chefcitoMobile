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
    var entradasDataSource:UICollectionViewDiffableDataSource<Section, RecipeModel>! = nil
    
    @IBOutlet weak var viewSopas: UIView!
    @IBOutlet weak var sopasCollectionView: UICollectionView!
    var sopasDataSource:UICollectionViewDiffableDataSource<Section, RecipeModel>! = nil
    
    @IBOutlet weak var viewPlato: UIView!
    @IBOutlet weak var platoCollectionView: UICollectionView!
    var platoDataSource:UICollectionViewDiffableDataSource<Section, RecipeModel>! = nil
    
    @IBOutlet weak var viewPostres: UIView!
    @IBOutlet weak var postresCollectionView: UICollectionView!
    var postresDataSource:UICollectionViewDiffableDataSource<Section, RecipeModel>! = nil
    
    let limit = 5
    var recipesByCategory:[String: Array<RecipeModel>] = [:]
    var downloadedURLs:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
                
        prepareCollectionViews()
        
        if recipesByCategory.isEmpty {
            getCurrentRecipes()
        }
    }
    
    private func getDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, RecipeModel> {
        let dataSource = UICollectionViewDiffableDataSource<Section, RecipeModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, recipe: RecipeModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeMainCell", for: indexPath) as! RecipeMainViewCell
            cell.name.text = recipe.getName()
                        
            if let recipeImage = recipe.getImage() {
                cell.image.image = recipeImage
                return cell
            } else if recipe.getImageURL() != nil && self.downloadedURLs[recipe.getImageURL()!.absoluteString] == nil{
                cell.image.image = UIImage(named: "receta")
                self.loadImage(url: recipe.getImageURL()!) { image in
                    var dataSource:UICollectionViewDiffableDataSource<Section, RecipeModel>?
                    
                    switch recipe.getCategory(){
                    case RecipeModel.RecipeCategories.entrada.rawValue:
                        dataSource = self.entradasDataSource
                    case RecipeModel.RecipeCategories.sopa.rawValue:
                        dataSource = self.sopasDataSource
                    case RecipeModel.RecipeCategories.plato.rawValue:
                        dataSource = self.platoDataSource
                    case RecipeModel.RecipeCategories.postre.rawValue:
                        dataSource = self.postresDataSource
                    default:
                        print("Invalid category")
                    }
                    
                    if let currentDataSource = dataSource {
                        var updatedSnapshot = currentDataSource.snapshot()
                        recipe.setImage(image: image)
                        self.recipesByCategory[recipe.getCategory()]![indexPath.row] = recipe
                        self.downloadedURLs[recipe.getImageURL()!.absoluteString] = recipe.getImageURL()!.absoluteString
                        updatedSnapshot.reloadItems([recipe])
                        currentDataSource.apply(updatedSnapshot, animatingDifferences: true)
                    }
                }
            }
            
            return cell
        }
        
        return dataSource
    }
    
    private func loadImage(url: URL, completion: @escaping(UIImage) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    private func prepareCollectionViews() {
        self.entradastCollectionView.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
        self.entradastCollectionView.delegate = self
        self.entradasDataSource = getDataSource(collectionView: self.entradastCollectionView)
        self.entradastCollectionView.dataSource = self.entradasDataSource
        
        self.sopasCollectionView.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
        self.sopasCollectionView.delegate = self
        self.sopasDataSource = getDataSource(collectionView: self.sopasCollectionView)
        self.sopasCollectionView.dataSource = self.sopasDataSource
        
        self.platoCollectionView.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
        self.platoCollectionView.delegate = self
        self.platoDataSource = getDataSource(collectionView: self.platoCollectionView)
        self.platoCollectionView.dataSource = self.platoDataSource
                
        self.postresCollectionView.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
        self.postresCollectionView.delegate = self
        self.postresDataSource = getDataSource(collectionView: self.postresCollectionView)
        self.postresCollectionView.dataSource = self.postresDataSource
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
                            let fileName = recipe["fileName"] as! String
                            let urlStr = "\(Constants.HOST)/recipes/\(fileName)"
                            let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            var imageURL: URL?
                            
                            if let url = encodedURL {
                                imageURL = URL(string: url)
                            }
                            
                            let currentRecipe = RecipeModel(name: recipe["name"] as! String, category: category, ingredients: recipe["ingredients"] as! [String], instructions: recipe["instructions"] as! String, count: recipe["count"] as! Int, image: nil, imageURL: imageURL)
                        
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
        for category in RecipeModel.RecipeCategories.allCases {
            var hideView = false
            var recipes:[RecipeModel] = []
            
            if let recipesTemp = self.recipesByCategory[category.rawValue] {
                hideView = false
                recipes = recipesTemp
            } else {
                hideView = true
                recipes.removeAll()
            }
            
            var initialSnapshot = NSDiffableDataSourceSnapshot<Section, RecipeModel>()
            initialSnapshot.appendSections([.main])
            initialSnapshot.appendItems(recipes)
            
            switch category {
            case .entrada:
                self.viewEntradas.isHidden = hideView
                self.entradasDataSource.apply(initialSnapshot, animatingDifferences: true)
            case .sopa:
                self.viewSopas.isHidden = hideView
                self.sopasDataSource.apply(initialSnapshot, animatingDifferences: true)
            case .plato:
                self.viewPlato.isHidden = hideView
                self.platoDataSource.apply(initialSnapshot, animatingDifferences: true)
            case .postre:
                self.viewPostres.isHidden = hideView
                self.postresDataSource.apply(initialSnapshot, animatingDifferences: true)
            }
        }
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
extension ChefcitoItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 280, height: 168)
        return size
    }
}
