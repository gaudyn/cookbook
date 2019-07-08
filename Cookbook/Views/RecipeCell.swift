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
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.RecipePhoto.bounds
        gradientLayer.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                           UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                           UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
                           UIColor.white.cgColor]
        
        self.RecipePhoto.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
