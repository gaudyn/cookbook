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

        
        addEditButton()
    }
    
    func addEditButton(){
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KindCell", for: indexPath) as? TypeTableViewCell else{
            fatalError("Wrong cell type in categories view")
        }

        cell.nameLabel.text = recipeTypes[indexPath.row].name
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func unwindToSave(sender: UIStoryboard){
        
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
