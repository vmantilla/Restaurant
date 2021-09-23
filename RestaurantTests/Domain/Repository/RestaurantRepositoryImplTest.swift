//
//  RestaurantRepositoryImplTest.swift
//  RestaurantTests
//
//  Created by Raul Mantilla on 22/09/21.
//

import XCTest
import SwiftyMocky
@testable import Restaurant

class RestaurantRepositoryImplTest: XCTestCase {
    
    private let dataSource = DataSourceMock()
    private var restaurantRepositoryImpl: RestaurantRepositoryImpl!

    override func setUp() {
        super.setUp()
        restaurantRepositoryImpl = RestaurantRepositoryImpl(restaurantDataSource: dataSource)
    }

    func testGetRestaurantListSuccess() {
        let calledCompletionBlock = expectation(description: "Should call completion block")
        
        Perform(dataSource, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.success([]))
        }) )
        
        restaurantRepositoryImpl.getRestaurantList { result in
            calledCompletionBlock.fulfill()
            switch result {
            case .success(let list) :
                XCTAssertEqual(list, [])
            case .failure(_):
                XCTFail("testGetRestaurantListSuccess should return success")
            }
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error)")
        }
    }
    
    func testGetRestaurantListFails() {
        let calledCompletionBlock = expectation(description: "Should call completion block")
        
        Perform(dataSource, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.failure(DataSourceError.parseError))
        }) )
        
        restaurantRepositoryImpl.getRestaurantList { result in
            calledCompletionBlock.fulfill()
            switch result {
            case .success(_) :
                XCTFail("testGetRestaurantListFails should return failure")
            case .failure(let error):
                XCTAssertEqual(error as! DataSourceError, DataSourceError.parseError)
            }
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error)")
        }
    }
}
