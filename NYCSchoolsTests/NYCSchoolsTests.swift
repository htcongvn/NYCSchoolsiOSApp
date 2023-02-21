//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Cong Huynh on 2023-02-17.
//

import XCTest
import Combine
@testable import NYCSchools

final class NYCSchoolsTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() async throws {
        try await super.setUp()
        cancellables.removeAll()
    }
    
    func testGettingSchoolsWithMockEmptyResult() {
        // this expection setup required for async operation
        let expectation = expectation(description: "test empty mock api")
        
        let mockAPI = MockSchoolAPI()
        mockAPI.loadState = .empty // .loaded loadState will fail the test
        
        let viewModel = SchoolsViewModel(apiService: mockAPI)
        
        // async operation inside the closure
        viewModel.getSchools()
        // listening to the published schools variable
        viewModel.$schools
            .receive(on: RunLoop.main)
            .sink { schools in
                XCTAssertTrue(schools.isEmpty == true, "Expected schools to be empty, but received some values")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
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
        
        viewModel.getSchools()
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { error in
                XCTAssertNotNil(error, "Expected to get an error, but recieved no error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
                
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
        
        viewModel.getSchools()
        
        viewModel.$schools
            .receive(on: RunLoop.main)
            .sink { schools in
                XCTAssertTrue(schools.isEmpty == false, "Expected to get schools")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
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
