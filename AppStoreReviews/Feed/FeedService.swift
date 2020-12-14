//
//  FeedService.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol FeedServiceInterface {
    var network: NetworkServiceInterface { get }
    
    func getAppleFeed(_ id: String, completion: @escaping NetworkResponseClosure<FeedRoot>)
}

class FeedService: FeedServiceInterface {
    var network: NetworkServiceInterface = NetworkService()
    
    func getAppleFeed(_ id: String, completion: @escaping NetworkResponseClosure<FeedRoot>) {
        network.fetch(.GetCustomerReviews(id: id), completion: completion)
    }
}


