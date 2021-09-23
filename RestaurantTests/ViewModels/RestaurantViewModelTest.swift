//
//  RestaurantViewModelTest.swift
//  RestaurantTests
//
//  Created by Raul Mantilla on 22/09/21.
//

import XCTest
import SwiftyMocky
@testable import Restaurant

struct MainPathMock {
    static let restaurants = "restaurants"
}

class RestaurantViewModelTest: XCTestCase {
    
    private var restaurantViewModel: RestaurantViewModel!
    private var restaurantUseCaseImpl = RestaurantUseCaseMock()
    private let testMainThread = DispatchQueue(label: "test_thread_main_restaurant")
    private let testBackgroundThread = DispatchQueue(label: "test_thread_background_restaurant")
    private var restaurants: [Restaurant] = []
    
    override func setUp() {
        super.setUp()
        restaurantViewModel = RestaurantViewModel(restaurantUseCase: restaurantUseCaseImpl,
                                                  mainThread: testMainThread,
                                                  backgroundThread: testBackgroundThread)
        if let response = self.getData(MainPathMock.restaurants, classType: [Restaurant].self) {
            self.restaurants = response
        }
    }
    
    func testGetRestaurantListSuccess() {
        let calledCompletionBlock = expectation(description: "Should call completion block")
        
        Perform(restaurantUseCaseImpl, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.success(self.restaurants))
        }) )
        
        //Then
        restaurantViewModel.action.send(.getRestaurants)
        testBackgroundThread.async { /* do nothing */ }
        testMainThread.async {
            calledCompletionBlock.fulfill()
        }
        sleep(2)
        XCTAssertEqual(restaurantViewModel.restaurants.count, restaurants.count)
        XCTAssertEqual(restaurantViewModel.isShowingError, false)
        
        waitForExpectations(timeout: 0.5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error)")
        }
    }
    
    func testGetRestaurantListFails() {
        let calledCompletionBlock = expectation(description: "Should call completion block")
        
        Perform(restaurantUseCaseImpl, .getRestaurantList(completionHandler: .any, perform: { completion in
            completion(.failure(DataSourceError.parseError))
        }) )
        
        restaurantViewModel.action.send(.getRestaurants)
        testBackgroundThread.async { /* do nothing */ }
        testMainThread.async {
            calledCompletionBlock.fulfill()
        }
        sleep(2)
        XCTAssertEqual(restaurantViewModel.restaurants, [])
        XCTAssertEqual(restaurantViewModel.isShowingError, true)
        
        waitForExpectations(timeout: 0.5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error)")
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
