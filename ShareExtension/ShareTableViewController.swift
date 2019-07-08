//
//  ShareTableViewController.swift
//  ShareExtension
//
//  Created by Administrator on 01/07/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import UIKit

protocol ShareSelectViewControllerDelegate: class{
    func selected(type:RecipeType)
}

class ShareTableViewController: UITableViewController {
    
    var recipeTypes: [RecipeType]!
    
    weak var delegate: ShareSelectViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        
        cell.textLabel!.text = recipeTypes[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate{
            delegate.selected(type: recipeTypes[indexPath.row])
        }
    }

}
