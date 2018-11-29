//
//  APIManager.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

//MARK: - Delegate
protocol APIManagerProtocol: class {
    func categoriesDownloaded(categoriesDownloaded: [Category])
}

//MARK: - Class
class APIManager: NSObject {
    
    //MARK: - Properties
    public static let sharedInstance = APIManager()
    weak var delegate: APIManagerProtocol!
    
    private struct URL {
        static let base = "https://yuka-dev.ams3.digitaloceanspaces.com/exercices/ios/"
        static let categories = "categories.json"
    }
    
    // MARK: - GET
    private func getURL(from url: String) -> String {
        return URL.base + url
    }
    
    // MARK: - Synchronization
    // Synchronize all the categories
    private func synchronizeCategories() {
        let url = getURL(from: URL.categories)

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var categories: [Category] = []

                for (_, subJson): (String, JSON) in json {
                    
                    // Check if children exist in category
                    if let childrens = subJson["children"].array {
                        for children in childrens {
                            
                            // Check if sub chidren exist in the subCategory
                            if let subChildrens = children["children"].array {
                                for subChildren in subChildrens {
                                    let category = Category()
                                    category.name = subJson["name"].stringValue + " → " + children["name"].stringValue + " → " + subChildren["name"].stringValue
                                    categories.append(category)
                                }
                            } else {
                                let category = Category()
                                category.name = subJson["name"].stringValue + " → " + children["name"].stringValue
                                categories.append(category)
                            }
                        }
                    } else {
                        let category = Category()
                        category.name = subJson["name"].stringValue
                        categories.append(category)
                    }
                }

                // Add categories in Database
                for category in categories {
                    DatabaseManager.sharedInstance.persistObject(object: category)
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.delegate.categoriesDownloaded(categoriesDownloaded: categories)
                    
                })

            case .failure(let error):
                print(error)
            }
        }
    }

    // Synchronize all the data
    func synchronize() {
        synchronizeCategories()
    }

    // Get all the Categories from database
    static func getAllCategories() -> [Category] {
        let categories = DatabaseManager.sharedInstance.getAllObjects(type: Category.self) as? [Category]

        return categories ?? []
    }
    
    // Search category
    static func searchCategory(filter: String) -> [Category] {
        return DatabaseManager.sharedInstance.getObjects(type: Category.self, filter: filter) as! [Category]
    }
}

