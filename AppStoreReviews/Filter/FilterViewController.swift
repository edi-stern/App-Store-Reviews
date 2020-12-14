//
//  FilterViewController.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    
    lazy var viewModel = FilterViewModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FilterCell.self, forCellReuseIdentifier: "starCell")
        tableView.rowHeight = 50
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "starCell", for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        
        cell.setup(stars: indexPath.row + 1,
                   selected: viewModel.selectedRow == indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.applyFilter(with: indexPath.row)
        tableView.reloadData()
    }
    
}
