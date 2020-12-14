//
//  AppDelegate.swift
//  AppStoreReviews
//
//  Created by Dmitrii Ivanov on 21/07/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

protocol Review: Codable {
    var author: String { get }
    var version: String { get }
    var rating: Int { get }
    var id: String { get }
    var title: String { get }
    var content: String { get }
}

extension Review {
    var ratingVersionText: String {
        return "\(rating.ratingText) (ver: \(version))"
    }
    
    func shortDescription() -> String {
        let contentArray = content.components(separatedBy: [" ", ",", ".", "-", "\n", ";", ":"]).reduce(into: [:]) { (counts, strings) in
            counts[strings, default: 0] += 1
        }
        
        return contentArray.sorted(by: {$0.value > $1.value})
            .filter { $0.key.count > 4 }
            .prefix(3)
            .map {$0.key}
            .joined(separator: " ")
    }
}

struct FeedRoot: Codable {
    var feed: Feed
    
    enum CodingKeys: String, CodingKey {
        case feed
    }
    
    struct Feed: Codable {
        
        var author: Author
        var entries: [Entry]
        
        enum CodingKeys: String, CodingKey {
            case author
            case entries = "entry"
        }
        
        struct InsideObject: Codable {
            var value: String
            
            enum CodingKeys: String, CodingKey {
                case value = "label"
            }
        }
        struct Author: Codable {
            var name: InsideObject
            var uri: InsideObject
            
            enum CodingKeys: String, CodingKey {
                case name
                case uri
            }
        }
        
        struct Entry: Review {
            var author: String {
                return authorObj.name.value
            }
            
            var version: String {
                return versionObj.value
            }
            
            var rating: Int {
                return Int(ratingObj.value) ?? 0
            }
            
            var id: String {
                return idObj.value
            }
            
            var title: String {
                return titleObj.value
            }
            
            var content: String {
                return contentObj.value
            }
            
            var authorObj: Author
            var versionObj: InsideObject
            var ratingObj: InsideObject
            var idObj: InsideObject
            var titleObj: InsideObject
            var contentObj: InsideObject
            
            enum CodingKeys: String, CodingKey {
                case authorObj = "author"
                case versionObj = "im:version"
                case ratingObj = "im:rating"
                case idObj = "id"
                case titleObj = "title"
                case contentObj = "content"
            }
        }
    }
}
