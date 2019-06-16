//
//  TypesTableViewController.swift
//  Cookbook
//
//  Created by Administrator on 09/06/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit

struct RecipeType: Codable{
    var name: String
}

class TypesTableViewController: UITableViewController {
    
    let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    var typesURL: URL!
    
    var recipeTypes = [RecipeType]()
    var selectedType: String!
    
    var movingForward = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typesURL = DocumentsDirectory?.appendingPathComponent("types")
        
        if let loadedTypes = loadTypes(){
            recipeTypes = loadedTypes
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movingForward = false
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as? TypeTableViewCell else{
            fatalError("Wrong cell type in the categories view")
        }

        cell.nameLabel.text = recipeTypes[indexPath.row].name
        
        if isCellSelected(cell){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    private func isCellSelected(_ cell: TypeTableViewCell) -> Bool{
        if cell.nameLabel.text == selectedType{
            return true
        }
        return false
    }

    
    @IBAction func unwindToTypesWithSender(sender: UIStoryboardSegue){
        guard let sourceView = sender.source as? TypeDetailTableViewController else {
            fatalError("Unexpected sender \(sender)")
        }
        if sourceView.saving{
            recipeTypes.append(RecipeType(name: sourceView.typeNameField.text!))
            tableView.insertRows(at: [IndexPath(row: recipeTypes.count-1, section: 0)], with: .automatic)
            try? saveTypes()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedType = recipeTypes[indexPath.row].name
        tableView.reloadData()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        movingForward = true
    }

    
    // MARK: - Navigation

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !movingForward{
            let navigationStack = navigationController!.viewControllers
            guard let detailView = navigationStack[navigationStack.count-1] as? RecipeDetailViewController else{
                fatalError("Unexpected parent")
            }
            if selectedType != nil{
                detailView.recipeType = selectedType
                detailView.typeLabel.text = selectedType
            }
        }
    }
    
    func saveTypes() throws{
        let encodedTypes = try? JSONEncoder().encode(recipeTypes)
        do{
            try encodedTypes?.write(to: typesURL)
        }catch{
            print("Couldn't save data")
        }
    }
    
    func loadTypes() -> [RecipeType]?{
        if let encodedData = try? Data(contentsOf: typesURL),
            let encodedRecipes = try? JSONDecoder().decode([RecipeType].self, from: encodedData){
                return encodedRecipes
        }
        return []
    }
    

}
