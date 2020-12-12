//
//  ChefcitoItemsViewController.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 25/11/20.
//

import UIKit

class ChefcitoItemsViewController: UIViewController {
    
    @IBOutlet weak var entradastCollectionView: UICollectionView!
    @IBOutlet weak var viewEntradas: UIView!
    
    @IBOutlet weak var viewSopas: UIView!
    @IBOutlet weak var sopasCollectionView: UICollectionView!
    
    @IBOutlet weak var viewPlato: UIView!
    @IBOutlet weak var platoCollectionView: UICollectionView!
    
    @IBOutlet weak var viewPostres: UIView!
    @IBOutlet weak var postresCollectionView: UICollectionView!
    
    var reloadData = true

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
    
    private func getCurrentRecipes() {
        print("Vamos a sacar todo")
        reloadData = false
        
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
