//
//  DatabaseManager.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: - Class
class DatabaseManager: NSObject {
    
    static let sharedInstance = DatabaseManager()
    
    func getRealm() -> Realm {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, _ in
                
        })
        if let realm = try? Realm() {
            return realm
        }
        
        // If this happen there is probably a problem and we should log it
        return try! Realm()
    }
    
    func persistObject(object: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func backgroundPersistObjects(_ objects: [Object]) {
        DispatchQueue(label: "background").async {
            let realm = self.getRealm()
            for object in objects as [Object] {
                try! realm.write {
                    realm.add(object, update: true)
                }
            }
        }
    }
    
    func getAllObjects<T>(type: T.Type) -> [Object] {
        let realm = getRealm()
        guard let guardedType = type as? Object.Type else {
            return []
        }
        let objects = realm.objects(guardedType)
        return Array(objects)
    }
    
    func getObjects<T>(type: T.Type, filter: String) -> [Object] {
        let realm = getRealm()
        guard let guardedType = type as? Object.Type else {
            return []
        }
        let objects = realm.objects(guardedType).filter(filter)
        return Array(objects)
    }
    
}

