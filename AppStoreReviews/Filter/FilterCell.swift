//
//  FilterCell.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(stars: Int, selected: Bool) {
        textLabel?.text = stars.ratingText
        isSelected = selected
    }
    
    override var isSelected: Bool {
        didSet {
            self.accessoryType = isSelected ? .checkmark : .none
        }
    }
}
