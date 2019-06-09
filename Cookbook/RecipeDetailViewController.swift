//
//  RecipeDetailViewController.swift
//  Cookbook
//
//  Created by Administrator on 24/04/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var recipe: Recipe?
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var recipeUrlField: UITextField!
    @IBOutlet weak var recipeImageCell: UITableViewCell!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var typeCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe != nil{
            recipeImageView.image = recipe!.Photo
            recipeNameField.text = recipe?.Name
            recipeUrlField.text = recipe?.Url?.absoluteString
            
        }

        setupFieldsDelegates()
        
        updateSaveButtonState()
        
        updateDeleteButtonState()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if textField === recipeNameField, !textField.isEmpty(){
            self.navigationItem.title = textField.text
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === recipeNameField{
            recipeUrlField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        
        hideKeyboard()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage!
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }else{
            fatalError("Something went wrong, \(info)")
        }
        
        recipeImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else{
            fatalError("Not inside a navigation controller")
        }
    }
    
    private func updateSaveButtonState(){
        if !recipeNameField.isEmpty(), !recipeUrlField.isEmpty(){
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
    private func updateDeleteButtonState(){
        if recipe == nil{
            deleteButton.isEnabled = false
        }else{
            deleteButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2){
            return recipeImageCell.frame.width
        }
        return recipeNameField.frame.height+16
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let button = sender as? UIBarButtonItem {
            
            if button === saveButton{
                
                let name = recipeNameField.text!
                let url = URL(string: recipeUrlField.text!)!
                let image = recipeImageView.image
                
                recipe = Recipe(name: name, photo: image, url: url)
            }
            
        }
    }
    
    @IBAction func tappedTypes(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showRecipeTypes", sender: typeCell)
    }
    
    
    private func setupFieldsDelegates(){
        recipeNameField.delegate = self
        recipeUrlField.delegate = self
    }
    
    private func hideKeyboard(){
        recipeImageView.resignFirstResponder()
        recipeUrlField.resignFirstResponder()
    }
    
}
extension UITextField{
    func isEmpty() -> Bool{
        return self.text?.isEmpty ?? true
    }
}
