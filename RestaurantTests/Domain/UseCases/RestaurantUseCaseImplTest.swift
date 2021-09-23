//
//  RestaurantUseCaseImplTest.swift
//  RestaurantTests
//
//  Created by Raul Mantilla on 22/09/21.
//

import XCTest
import SwiftyMocky
@testable import Restaurant

class RestaurantUseCaseImplTest: XCTestCase {
    
    private let restaurantRepository = RestaurantRepositoryMock()
    private var restaurantUseCaseImpl: RestaurantUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        restaurantUseCaseImpl = RestaurantUseCaseImpl(restaurantRepository: restaurantRepository)
    }
    
    func testGetRestaurantListSuccess() {
        let calledCompletionBlock = expectation(description: "Should call completion block")
        
        Perform(restaurantRepository, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.success([]))
        }) )
        
        restaurantUseCaseImpl.getRestaurantList { result in
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
        
        Perform(restaurantRepository, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.failure(DataSourceError.parseError))
        }) )
        
        restaurantUseCaseImpl.getRestaurantList { result in
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
