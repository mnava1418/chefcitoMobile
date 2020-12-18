//
//  RecipeMainViewCell.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 08/12/20.
//

import UIKit

class RecipeMainViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isFavorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
