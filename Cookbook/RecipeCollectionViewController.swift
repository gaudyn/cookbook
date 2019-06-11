//
//  RecipeCollectionViewController.swift
//  Cookbook
//
//  Created by Administrator on 20/04/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit
import os.log



final class RecipeCollectionViewController: UICollectionViewController {
    
    
    private let reuseIdentifier = "RecipeCell"
    
    private var selectedIndexPath: IndexPath?
    
    private var recipeKinds: [RecipeKind]!
    
    let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    var ArchiveURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        ArchiveURL = DocumentsDirectory?.appendingPathComponent("recipes")
        if let savedRecipes = loadRecipes(){
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
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
    
    @IBAction func unwindToRecipeCollectionView(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? RecipeDetailViewController,
            let recipe = sourceViewController.recipe{
            
            if selectedIndexPath != nil{
                recipeKinds[selectedIndexPath!.section].recipes[selectedIndexPath!.row] = recipe
                collectionView.reloadItems(at: [selectedIndexPath!])
                selectedIndexPath = nil
            }else{
                let sectionName = sourceViewController.recipeType
                var newIndexPath: IndexPath!
                if let section = recipeKinds.firstIndex(where: {recipeKind in return recipeKind.kind == sectionName }){
                    newIndexPath = IndexPath(row: recipeKinds![section].recipes.count, section: section)
                    recipeKinds![section].recipes.append(recipe)
                }else{
                    let newSection = recipeKinds.count
                    collectionView.insertSections(IndexSet(integer: newSection))
                    newIndexPath = IndexPath(row: recipeKinds![newSection].recipes.count, section: newSection)
                    recipeKinds![newSection].recipes.append(recipe)
                }
                
                collectionView.insertItems(at: [newIndexPath])
            }
            try? saveRecipes()
        }
    }
    
    @IBAction func unwindToDeleteRecipe(sender: UIStoryboardSegue){
        if sender.source is RecipeDetailViewController{
            if selectedIndexPath != nil{
                
                recipeKinds[selectedIndexPath!.section].recipes.remove(at: selectedIndexPath!.row)
                collectionView.reloadData()
                selectedIndexPath = nil
                try? saveRecipes()
                
            }
        }
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
    
    
    
    func saveRecipes() throws{
        let encodedRecipes = try? JSONEncoder().encode(recipeKinds)
        do{
            try encodedRecipes?.write(to: ArchiveURL)
        }catch{
            print("Couldn't save data")
        }
        
    }
    
    func loadRecipes() -> [RecipeKind]?{
        if let encodedData = try? Data(contentsOf: ArchiveURL){
            if let encodedRecipes = try? JSONDecoder().decode([RecipeKind].self, from: encodedData){
                return encodedRecipes
            }
        }
        return []
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
