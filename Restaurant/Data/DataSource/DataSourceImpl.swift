//
//  DataSourceImpl.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import Foundation

struct MainPath {
    static let restaurants = "restaurants"
}

class DataSourceImpl: DataSource {
    func getRestaurantList(completionHandler completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        
        let fileName = MainPath.restaurants
        if let jsonResponse = self.getData(fileName, classType: RestaurantResponse.self) {
            completion(.success(jsonResponse.restaurants))
        } else {
            completion(.failure(DataSourceError.parseError))
        }
    }
    
    func getData<T: Decodable>(_ fileName: String, classType: T.Type) -> T? {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8),
               let object = try? JSONDecoder().decode(classType.self, from: jsonData) {
                return object
            }
        } catch {
            return nil
        }
        return nil
    }
}
