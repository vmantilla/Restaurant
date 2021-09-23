//
//  RestaurantRepositoryImpl.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation
struct RestaurantRepositoryImpl: RestaurantRepository {
    
    private var restaurantDataSource: DataSource
    
    init(restaurantDataSource: DataSource = DataSourceImpl()) {
        self.restaurantDataSource = restaurantDataSource
    }
    
    func getRestaurantList(completionHandler completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        self.restaurantDataSource.getRestaurantList() { result in
            completion(result)
        }
    }
}
