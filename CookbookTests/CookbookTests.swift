//
//  CookbookTests.swift
//  CookbookTests
//
//  Created by Administrator on 08/04/2019.
//  Copyright © 2019 Gaudyn. All rights reserved.
//

import XCTest
@testable import Cookbook

class CookbookTests: XCTestCase {

    
    // Recipe class tests
    func testRecipeEmpty() {
        let newRecipe = Recipe(name: "", photo: nil, url: "")
        XCTAssert(newRecipe == nil)
    }

    func testRecipeName() {
        let recipeName = "Testing, testing"
        let newRecipe = Recipe(name: recipeName, photo: nil, url: "")
        XCTAssert(newRecipe!.Name == recipeName)
    }
    
    
}
