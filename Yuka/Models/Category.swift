//
//  Category.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - Class
class Category: Object {
    
    @objc dynamic var name = ""
    var children : List<Children>?
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
