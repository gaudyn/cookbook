//
//  RecipeViewCell.swift
//  Cookbook
//
//  Created by Gniewomir Gaudyn on 20/04/2019.
//  Copyright © 2019 Gniewomir Gaudyn. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    @IBOutlet weak var RecipePhoto: UIImageView!
    @IBOutlet weak var RecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.RecipePhoto.layer.cornerRadius = 10
        
        
        createGradientLayer()
        
    }
    
    private func createGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.frame = self.RecipePhoto.bounds
        gradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                           UIColor.white.cgColor]
        
        self.RecipePhoto.layer.insertSublayer(gradient, at: 0)
    }
    
    
}
