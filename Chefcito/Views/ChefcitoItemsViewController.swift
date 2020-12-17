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
    var reloadData = true
    var recipesByCategory:[String: Array<RecipeModel>] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        let collectionViews:[UICollectionView] = [entradastCollectionView, sopasCollectionView, platoCollectionView, postresCollectionView]
        prepareCollectionViews(collectionViews: collectionViews)
    }
    
    private func prepareCollectionViews(collectionViews:[UICollectionView]) {
        for item in collectionViews {
            item.dataSource = self
            item.delegate = self
            item.register(UINib(nibName: "RecipeMainViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeMainCell")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if reloadData {
            getCurrentRecipes()
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
                if let recipesCategory = json["recipes"] as? Dictionary<String, Any> {
                    for (category, recipes) in recipesCategory  {
                        if self.recipesByCategory[category] == nil {
                            self.recipesByCategory[category] = []
                        }
                        
                        for recipe in recipes as! [Dictionary<String, Any>]{
                            let currentRecipe = RecipeModel(name: recipe["name"] as! String, category: category, ingredients: recipe["ingredients"] as! [String], instructions: recipe["instructions"] as! String, count: recipe["count"] as! Int, image: nil)
                            //fileName = "5fd512657f6f2707b56ed6f6|5fdaa68ab28d560e9630f240.jpeg";
                            self.recipesByCategory[category]!.append(currentRecipe)
                        }
                     }
                }
                self.reloadData = false
            } else {
                self.showMessage()
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
extension ChefcitoItemsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeMainCell", for: indexPath) as! RecipeMainViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 280, height: 168)
        return size
    }
}
