//
//  FilterViewModel.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol FilterViewModelDelegate {
    func filterReviews(stars: Int?)
}

class FilterViewModel {
    
    var selectedRow: Int? = nil
    var delegate: FilterViewModelDelegate?
    
    func applyFilter(with index: Int) {
        delegate?.filterReviews(stars: index == selectedRow ? nil : index + 1)
        
        selectedRow = index == selectedRow ? nil : index
    }
}

