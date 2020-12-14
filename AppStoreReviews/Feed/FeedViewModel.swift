//
//  FeedViewModel.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol FeedViewModelDelegate {
    func callFinished(errorMessage: String?)
    func reloadTableView()
}

class FeedViewModel {
    var feedService: FeedServiceInterface
    let id = "474495017"
   
    var reviews: [Review]?
    var defaultReviewsList: [Review]?
    
    var delegate : FeedViewModelDelegate?
    var selectedFilter: Int? = nil
    
    init(feedService: FeedServiceInterface) {
        self.feedService = feedService
        
        getAppleFeed(id)
    }
    
    func filteredReviews(by stars: Int) -> [Review] {
        return defaultReviewsList?.filter({ $0.rating == stars }) ?? []
    }
    
    func getAppleFeed(_ id: String) {
        selectedFilter = nil
        feedService.getAppleFeed(id) { [weak self] (result) in
            guard let welf = self else {
                return
            }
           
            switch result {
            case .failure(let error):
                welf.delegate?.callFinished(errorMessage: error.localizedDescription)
            case .success(let feedRoot):
                welf.defaultReviewsList = feedRoot.feed.entries
                welf.reviews = feedRoot.feed.entries
                welf.delegate?.callFinished(errorMessage: nil)
            }
        }
    }
}

extension FeedViewModel: FilterViewModelDelegate {
        func filterReviews(stars: Int?) {
            if let stars = stars {
                selectedFilter = stars - 1
                reviews = filteredReviews(by: stars)
            } else {
                selectedFilter = nil
                reviews = defaultReviewsList
            }
            delegate?.reloadTableView()
        }
}
