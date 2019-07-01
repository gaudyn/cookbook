//
//  sharedContainer.swift
//  Cookbook
//
//  Created by Administrator on 02/07/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import Foundation

extension FileManager{
    static func sharedContainerURL() -> URL{
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.gaudyn.cookbook")!
    }
}
