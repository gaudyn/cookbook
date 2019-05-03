//
//  RecipeClass.swift
//  Cookbook
//
//  Created by Administrator on 20/04/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import Foundation
import UIKit

class Recipe: Codable{
    
    var Name: String
    var Photo: UIImage?
    var Url: URL?
    
    enum PropertyKey: String, CodingKey{
        case name
        case url
        case photo = "photoData"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("recipes")
    
    init?(name: String, photo: UIImage? = #imageLiteral(resourceName: "emptyPhoto"), url: URL) {
        guard !name.isEmpty else{
            return nil
        }
        self.Name = name
        
        self.Photo = photo ?? #imageLiteral(resourceName: "emptyPhoto")
        
        self.Url = url
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PropertyKey.self)
        try container.encode(self.Name, forKey: .name)
        try container.encode(self.Url, forKey: .url)
        
        let photoData = self.Photo?.pngData()
        try container.encode(photoData, forKey: .photo)
        
    }
    
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: PropertyKey.self)
        self.Name = try values.decode(String.self, forKey: .name)
        self.Url = try values.decode(URL.self, forKey: .url)
        
        let photoData = try values.decode(Data.self, forKey: .photo)
        self.Photo = UIImage.init(data: photoData)
        
        
    }
    
}
