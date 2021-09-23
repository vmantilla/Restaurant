//
//  RestaurantResponse.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation

struct RestaurantResponse: Decodable {
  let restaurants: [Restaurant]
  
  enum CodingKeys: String, CodingKey {
    case restaurants = "restaurants"
  }
}
