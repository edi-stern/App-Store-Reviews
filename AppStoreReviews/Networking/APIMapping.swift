//
//  APIMapping.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

enum ExpectedResponseType {
    case Dictionary
}

enum HTTPMethod: String {
    case Get = "GET"
}

enum APIMapping {
    
    case GetCustomerReviews(id: String)
}

extension APIMapping {
    
    var fullURL: URL? {
        switch self {
        default:
            return URL(string:"\(baseURL)\(path)")
        }
    }
    
    var baseURL: String {
        switch self {
        case .GetCustomerReviews:
            return "https://itunes.apple.com/nl/rss/customerreviews"
        }
    }
    
    var path: String {
        switch self {
        case .GetCustomerReviews(let id):
            return "/id=\(id)/sortby=mostrecent/json"
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .GetCustomerReviews:
            guard let url = fullURL else {
                preconditionFailure("Invalid URL used to create URL instance")
            }
           
            return URLRequest(url: url)
        }
    }
    
}



