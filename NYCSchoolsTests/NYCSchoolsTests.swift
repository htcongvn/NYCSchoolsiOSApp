//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Cong Huynh on 2023-02-17.
//

import XCTest
@testable import NYCSchools

final class NYCSchoolsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    
    }
    
    func testGettingSchoolsWithMockEmptyResult() {
        // this expection setup required for async operation
        let expectation = expectation(description: "test empty mock api")
        
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .empty // .loaded loadState will fail the test
        
        let viewModel = SchoolsViewModel(apiService: mockAPI)
        
        // async operation inside the closure
        viewModel.getSchools { schools, error in
            XCTAssertTrue(schools?.isEmpty == true, "Expected schools to be empty, but received some values")
            
            // fulfill the expectation required for async operation
            expectation.fulfill()
        }
        
        // wait for fulfilling the expectation inside the closure to get done otherwise timeout occurs after 1.0 second
        waitForExpectations(timeout: 1.0) {error in
            if let error = error {
                XCTFail("Expectation failed \(error.localizedDescription)")
            }
        }
    }
    
    func testGettingSchoolsWithMockErrorResult() {
        let expectation = expectation(description: "test error mock api")
        
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .error
        
        let viewModel = SchoolsViewModel(apiService: mockAPI)
        
        viewModel.getSchools { schools, error in
            XCTAssertTrue(schools == nil, "Expected to get no schools, but received schools")
            XCTAssertNotNil(error, "Expected to get an error, but recieved no error")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) {error in
            if let error = error {
                XCTFail("Expectation failed \(error.localizedDescription)")
            }
        }
        
    }
    
    func testGettingSchoolsWithMockSuccessResult() {
        let expectation = expectation(description: "test success mock api")
        
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .loaded
        
        let viewModel = SchoolsViewModel(apiService: mockAPI)
        
        viewModel.getSchools { schools, error in
            XCTAssertTrue(schools?.isEmpty == false, "Expected to get schools")
            XCTAssertNil(error, "Expected error to be nil")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) {error in
            if let error = error {
                XCTFail("Expectation failed \(error.localizedDescription)")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
