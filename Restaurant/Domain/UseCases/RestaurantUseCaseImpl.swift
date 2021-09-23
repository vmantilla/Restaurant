//
//  RestaurantUseCaseImpl.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation
struct RestaurantUseCaseImpl: RestaurantUseCase {
    
    private var restaurantRepository: RestaurantRepository
    
    init(restaurantRepository: RestaurantRepository = RestaurantRepositoryImpl()) {
        self.restaurantRepository = restaurantRepository
    }
    
    func getRestaurantList(completionHandler completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        self.restaurantRepository.getRestaurantList() { result in
            completion(result)
        }
    }
}
