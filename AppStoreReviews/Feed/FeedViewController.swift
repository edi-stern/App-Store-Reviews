//
//  AppDelegate.swift
//  AppStoreReviews
//
//  Created by Dmitrii Ivanov on 21/07/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    
    lazy var viewModel = FeedViewModel(feedService: FeedService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "App store reviews"
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 160
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped(_:)))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviews?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let c = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        
        guard let item = viewModel.reviews?[indexPath.row] else {
            return c
        }
        c.update(item: item, isFilterActive: viewModel.selectedFilter != nil)
        
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = viewModel.reviews?[indexPath.row] else {
            return
        }
        let vc = DetailsViewController()
        vc.viewModel.review = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.getAppleFeed(viewModel.id)
    }
    
    @objc func filterTapped(_ sender: Any) {
        guard let rightBarButton = sender as? UIBarButtonItem else {
            return
        }
        
        let filterViewController = FilterViewController()
        
        filterViewController.modalPresentationStyle = .popover
        filterViewController.preferredContentSize = CGSize (width: self.view.frame.width / 2,
                                                            height: 250)
        guard let popover = filterViewController.popoverPresentationController else {
            return
        }
        
        filterViewController.viewModel.delegate = viewModel.self
        filterViewController.viewModel.selectedRow = viewModel.selectedFilter
        
        popover.delegate = self
        popover.barButtonItem = rightBarButton
        popover.permittedArrowDirections = .up
        
        present(filterViewController, animated: true, completion: nil)
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func callFinished(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            if let errorMessage = errorMessage {
                self?.showAlert(title: "Error", message: errorMessage)
            } else {
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FeedViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
