//
//  RecipeShowViewCellTableViewCell.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 18/12/20.
//

import UIKit

class RecipeShowViewCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isFavorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
