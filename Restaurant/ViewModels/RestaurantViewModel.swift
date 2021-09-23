//
//  RestaurantViewModel.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject, Identifiable {
    
    @Published var isShowingError: Bool = false
    @Published var restaurants: [Restaurant] = []
    
    var sortingValue: SortBy = .popularity
    var restaurantsData: [Restaurant] = []
    
    private var restaurantUseCase: RestaurantUseCase
    private let mainThread: DispatchQueue
    private let backgroundThread: DispatchQueue
    private var cancelables = Set<AnyCancellable>()
    
    let action = PassthroughSubject<UIAction, Never>()
    
    init(restaurantUseCase: RestaurantUseCase = RestaurantUseCaseImpl(),
         mainThread: DispatchQueue = DispatchQueue.main,
         backgroundThread: DispatchQueue = DispatchQueue.global()) {
        self.restaurantUseCase = restaurantUseCase
        self.mainThread = mainThread
        self.backgroundThread = backgroundThread
        self.cancelables = [
            self.action
                .subscribe(on: self.backgroundThread)
                .receive(on: self.backgroundThread)
                .sink(receiveValue: { [weak self] action in
                    self?.processAction(action)
                })
        ]
    }
    
    private func processAction(_ action: UIAction) {
        switch action {
        case .getRestaurants:
            self.getRestaurant()
        case .sortRestaurant(by: let sortingValue):
            self.sortRestaurant(by: sortingValue)
        case .sortRestaurantBy(text: let string):
            self.sortRestaurantBy(text: string)
        }
    }
    
    private func getRestaurant() {
        self.restaurantUseCase.getRestaurantList() { result in
            self.mainThread.async {
                switch result {
                case .success(let result):
                    self.restaurantsData = result
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }
    
    private func sortRestaurant(by: SortBy) {
        
        self.sortingValue = by
        var sortedData: [Restaurant] = []
        
        switch by {
        case .bestMatch:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.bestMatch < $1.sortingValues.bestMatch})
        case .newest:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.newest < $1.sortingValues.newest})
        case .ratingAverage:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.ratingAverage < $1.sortingValues.ratingAverage})
        case .distance:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                        {$0.sortingValues.distance < $1.sortingValues.distance})
        case .popularity:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.popularity < $1.sortingValues.popularity})
        case .averageProductPrice:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.averageProductPrice < $1.sortingValues.averageProductPrice})
        case .deliveryCosts:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts})
        case .minCost:
            sortedData = self.restaurantsData.sorted(by:
                                                        {$0.status.rawValue < $1.status.rawValue},
                                                     {$0.sortingValues.minCost < $1.sortingValues.minCost})
        }
        self.restaurants = sortedData
    }
    
    private func sortRestaurantBy(text: String) {
        if text.isEmpty {
            self.sortRestaurant(by: sortingValue)
        } else {
            self.restaurants = self.restaurants.filter({$0.name.lowercased().contains(text.lowercased())})
        }
    }
    
    func restaurantSortedValue(_ restaurant: Restaurant) -> Double {
        switch sortingValue {
        case .bestMatch:
            return restaurant.sortingValues.bestMatch
        case .newest:
            return restaurant.sortingValues.newest
        case .ratingAverage:
            return restaurant.sortingValues.ratingAverage
        case .distance:
            return restaurant.sortingValues.distance
        case .popularity:
            return restaurant.sortingValues.popularity
        case .averageProductPrice:
            return restaurant.sortingValues.averageProductPrice
        case .deliveryCosts:
            return restaurant.sortingValues.deliveryCosts
        case .minCost:
            return restaurant.sortingValues.minCost
        }
    }
    
    private func showError(_ error: Error) {
        self.isShowingError = true
    }
    
}

extension RestaurantViewModel {
    enum UIAction {
        case getRestaurants
        case sortRestaurant(by: SortBy)
        case sortRestaurantBy(text: String)
    }
    
    enum SortBy: Int {
        case bestMatch
        case newest
        case ratingAverage
        case distance
        case popularity
        case averageProductPrice
        case deliveryCosts
        case minCost
        
        func toString() -> String {
            switch self {
            case .bestMatch:
                return "Best Match"
            case .newest:
                return "Newest"
            case .ratingAverage:
                return "Rating Average"
            case .distance:
                return "Distance"
            case .popularity:
                return "Popularity"
            case .averageProductPrice:
                return "Average Product Price"
            case .deliveryCosts:
                return "Delivery Costs"
            case .minCost:
                return "Min Cost"
            }
        }
    }
}
