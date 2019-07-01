//
//  CategoryStruct.swift
//  Cookbook
//
//  Created by Administrator on 01/07/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import Foundation

struct RecipeType: Codable{
    var name: String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let typesURL = DocumentsDirectory!.appendingPathComponent("types")
    
}
extension RecipeType{
    static func loadTypes() -> [RecipeType]?{
        if let encodedData = try? Data(contentsOf: typesURL),
            let encodedRecipes = try? JSONDecoder().decode([RecipeType].self, from: encodedData){
            return encodedRecipes
        }
        return []
    }
    
    static func saveTypes(recipeTypes: [RecipeType]) throws{
        let encodedTypes = try? JSONEncoder().encode(recipeTypes)
        do{
            try encodedTypes?.write(to: typesURL)
        }catch{
            print("Couldn't save data")
        }
    }
}

