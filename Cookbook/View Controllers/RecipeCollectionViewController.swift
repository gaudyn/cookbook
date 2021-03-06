//
//  RecipeCollectionViewController.swift
//  Cookbook
//
//  Created by Gniewomir Gaudyn on 20/04/2019.
//  Copyright © 2019 Gniewomir Gaudyn. All rights reserved.
//

import UIKit
import os.log



final class RecipeCollectionViewController: UICollectionViewController {
    
    
    private let reuseIdentifier = "RecipeCell"
    
    private var selectedIndexPath: IndexPath?
    
    private var recipeKinds: [RecipeKind]!
    
    let DocumentsDirectory = FileManager.sharedContainerURL()
    var recipesURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if let savedRecipes = Recipe.loadRecipes(){
            recipeKinds = savedRecipes
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func showRecipeUrl(_ sender: UITapGestureRecognizer) {
        if sender.state != .ended{
            return
        }
        if let selectedRecipe = cellTouched(sender: sender),
            selectedRecipe.Url != nil{
            UIApplication.shared.open(selectedRecipe.Url!, options: [:], completionHandler: nil)
        }
    }
    @IBAction func longPressEdit(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began{
            return
        }
        if let selectedRecipe = cellTouched(sender: sender){
            let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Recipe detail") as! RecipeDetailViewController
            viewController.recipe = selectedRecipe
            viewController.recipeType = recipeKinds![selectedIndexPath!.section].kind
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
    
    @IBAction func unwindToRecipeCollectionView(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? RecipeDetailViewController,
            let recipe = sourceViewController.recipe,
            let sectionName = sourceViewController.recipeType{
            
            if selectedIndexPath != nil{
                if sectionName != recipeKinds[selectedIndexPath!.section].kind{
                    
                    if recipeKinds.firstIndex(where: { recipeKind in return recipeKind.kind == sectionName}) == nil{
                        recipeKinds.append(RecipeKind(kind: sectionName, recipes: []))
                        collectionView.insertSections(IndexSet(integer: recipeKinds.count-1))
                    }
                    
                    let newSection = recipeKinds.firstIndex(where: { recipeKind in return recipeKind.kind == sectionName})!
                    
                    recipeKinds[selectedIndexPath!.section].recipes.remove(at: selectedIndexPath!.row)
                    recipeKinds![newSection].recipes.append(recipe)
                    
                    collectionView.moveItem(at: selectedIndexPath!, to: IndexPath(row: recipeKinds[newSection].recipes.count-1, section: newSection))
                    
                    if isSectionEmpty(selectedIndexPath!.section){
                        recipeKinds.remove(at: selectedIndexPath!.section)
                        collectionView.deleteSections(IndexSet(integer: selectedIndexPath!.section))
                    }
                    
                }else{
                recipeKinds[selectedIndexPath!.section].recipes[selectedIndexPath!.row] = recipe
                collectionView.reloadItems(at: [selectedIndexPath!])
                }
                selectedIndexPath = nil
            }else{
                if let section = recipeKinds.firstIndex(where: {recipeKind in return recipeKind.kind == sectionName }){
                    recipeKinds![section].recipes.append(recipe)
                    
                }else{
                    let newSection = recipeKinds.count
                    recipeKinds.append(RecipeKind(kind: sectionName, recipes: [recipe]))
                    collectionView.insertSections(IndexSet(integer: newSection))
                    
                }
                
                collectionView.reloadData()
            }
            try? Recipe.saveRecipes(recipeKinds: recipeKinds)
        }
    }
    
    @IBAction func unwindToDeleteRecipe(sender: UIStoryboardSegue){
        if sender.source is RecipeDetailViewController{
            if selectedIndexPath != nil{
                
                recipeKinds[selectedIndexPath!.section].recipes.remove(at: selectedIndexPath!.row)
                if isSectionEmpty(selectedIndexPath!.section){
                    recipeKinds.remove(at: selectedIndexPath!.section)
                }
                collectionView.reloadData()
                selectedIndexPath = nil
                try? Recipe.saveRecipes(recipeKinds: recipeKinds)
                
            }
        }
    }
    
    private func isSectionEmpty(_ section: Int) -> Bool{
        return recipeKinds[section].recipes.count == 0
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return recipeKinds.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipeKinds[section].recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.isOpaque = true
        cell.dropShadow(XOffset: -1, YOffset: 1)
        
        let selectedRecipe = recipeKinds[indexPath.section].recipes[indexPath.row]
        cell.RecipeLabel.text = selectedRecipe.Name
        cell.RecipePhoto.image = selectedRecipe.Photo
        
        
        return cell
    }
    
    
    
    private func cellTouched(sender: UIGestureRecognizer) -> Recipe?{
        let pressLocation = sender.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: pressLocation){
            selectedIndexPath = indexPath
            return recipeKinds[indexPath.section].recipes[indexPath.row]
        }
        return nil
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RecipeHeader", for: indexPath) as? RecipeHeaderView
            else{
                fatalError("Invalid view type")
            }
            
            let headerText = recipeKinds[indexPath.section].kind
            headerView.sectionLabel.text = headerText
            
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    
    
    
    
}
extension UIView{
    
    func dropShadow(XOffset: Double, YOffset: Double){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: XOffset, height: YOffset)
        self.layer.shadowRadius = 2
    }
}
