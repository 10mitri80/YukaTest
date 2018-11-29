//
//  Children.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - Class
class Children: Object {
    
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
