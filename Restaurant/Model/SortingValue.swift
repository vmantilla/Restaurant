//
//  SortingValue.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation

struct SortingValue: Decodable {
    let bestMatch: Double
    let newest: Double
    let ratingAverage: Double
    let distance: Double
    let popularity: Double
    let averageProductPrice: Double
    let deliveryCosts: Double
    let minCost: Double
    
    enum CodingKeys: String, CodingKey {
        case bestMatch
        case newest
        case ratingAverage
        case distance
        case popularity
        case averageProductPrice
        case deliveryCosts
        case minCost
    }
}
