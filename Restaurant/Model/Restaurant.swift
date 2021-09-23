//
//  Restaurant.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation

struct Restaurant: Decodable, Equatable {
    var identifier: String
    var name: String
    var status: RestaurantStatusId
    var sortingValues: SortingValue
    
    enum CodingKeys: String, CodingKey {
      case identifier = "id"
      case name
      case status
      case sortingValues
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            identifier = try  values.decode(String.self, forKey: .identifier)
        } catch {
            identifier = "0"
        }
        
        do {
            name = try values.decode(String.self, forKey: .name)
        } catch {
            name = ""
        }
        
        do {
            sortingValues = try values.decode(SortingValue.self, forKey: .sortingValues)
        } catch {
            sortingValues = SortingValue(bestMatch: 0, newest: 0, ratingAverage: 0, distance: 0, popularity: 0, averageProductPrice: 0, deliveryCosts: 0, minCost: 0)
        }
        
        do {
            let statusString = try values.decode(RestaurantStatus.self, forKey: .status)
            switch statusString {
            case .closed:
                status = .closed
            case .orderAhead:
                status = .orderAhead
            case .open:
                status = .open
            }
        } catch {
            status = .closed
        }
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Restaurant {
    init(identifier: String, name: String, status: RestaurantStatusId, sortingValues: SortingValue) {
        self.identifier = identifier
        self.name = name
        self.status = status
        self.sortingValues = sortingValues
    }
}

enum RestaurantStatusId: Int, Codable {
    case open
    case orderAhead
    case closed
    
    func toRestaurantStatus() -> RestaurantStatus {
        switch self {
        case .closed:
            return .closed
        case .orderAhead:
            return .orderAhead
        case .open:
            return .open
        }
    }
}

enum RestaurantStatus: String, Codable {
    case open
    case orderAhead = "order ahead"
    case closed
}
