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
    
    var recipeTypes = [RecipeType]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        return cell
    }

    
    @IBAction func unwindToTypesWithSender(sender: UIStoryboardSegue){
        guard let sourceView = sender.source as? TypeDetailTableViewController else {
            fatalError("Unexpected sender \(sender)")
        }
        if sourceView.saving{
            recipeTypes.append(RecipeType(name: sourceView.typeNameField.text!))
            tableView.insertRows(at: [IndexPath(row: recipeTypes.count-1, section: 0)], with: .automatic)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
