//
//  RestaurantRepository.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation

//sourcery: AutoMockable
protocol RestaurantRepository {
    func getRestaurantList(completionHandler completion: @escaping (Result<[Restaurant], Error>) -> Void)
}
