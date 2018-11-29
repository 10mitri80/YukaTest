//
//  CategoryTableViewCell.swift
//  Yuka
//
//  Created by Dimitri Cadars on 2018-11-27.
//  Copyright © 2018 Dimitri Cadars. All rights reserved.
//

import UIKit

//MARK: - Class
class CategoryTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var category: Category? {
        didSet {
            configureCell()
        }
    }

    @IBOutlet weak var categoryLabel: UILabel!
    
    func configureCell() {
        categoryLabel.text = category?.name
    }

}
