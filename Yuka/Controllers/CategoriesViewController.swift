//
//  CategoriesViewController.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import UIKit

//MARK: - Class
class CategoriesViewController: UIViewController, APIManagerProtocol {

    //MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [Category] = []
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        APIManager.sharedInstance.delegate = self
        categories = APIManager.getAllCategories()
        tableView.reloadData()
    }
    
    func categoriesDownloaded(categoriesDownloaded: [Category]) {
        categories = categoriesDownloaded
        tableView.reloadData()
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoriesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.category = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Catégorie : ", message: categories[indexPath.row].name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate
extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText != "" {
            self.categories = APIManager.searchCategory(filter: "name contains[cd] '\(searchText)'")
        } else {
            self.categories = APIManager.getAllCategories()
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

