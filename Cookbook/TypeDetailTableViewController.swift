//
//  TypeDetailTableViewController.swift
//  Cookbook
//
//  Created by Administrator on 09/06/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit

class TypeDetailTableViewController: UITableViewController, UITextFieldDelegate{

    
    @IBOutlet weak var typeNameField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var saving: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
        
        typeNameField.delegate = self
        
        saving = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIBarButtonItem === saveButton{
            saving = true
        }
    }
    
    func updateSaveButtonState(){
        if typeNameField.isEmpty(){
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
    }
    

}
