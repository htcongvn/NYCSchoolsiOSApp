//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-19.
//

import Foundation

class SchoolsViewModel {
    // private(set): schools variable, which is an instance property, is just only able to be set inside the class
    // but can still be accessed from outside the class
    private(set) var schools: [School] = []
    private(set) var error: DataError? = nil
    
    private let apiService: SchoolAPILogic
    
    init(apiService: SchoolAPILogic = SchoolAPI()) {
        self.apiService = apiService
    }
    
    // we would use escaping closure as a callback
    func getSchools(completion: @escaping (([School]?, DataError?) -> Void )) {
        // we would use service in network layer
        apiService.getSchools { [weak self] result in
            switch result {
            case .success(let schools):
                self?.schools = schools ?? []
                completion(schools, nil) // no error
            case .failure(let error):
                self?.error = error
                completion(nil, error) // schools should be nill due to error
            }
        }
    }
}
