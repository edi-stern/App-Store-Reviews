//
//  Extension+Int.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

extension Int {
    var ratingText: String {
        return String(repeating: "⭐️", count: self)
    }
}
