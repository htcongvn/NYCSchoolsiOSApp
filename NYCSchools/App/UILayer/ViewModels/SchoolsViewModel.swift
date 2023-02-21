//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-19.
//

import Foundation
import Combine

class SchoolsViewModel {
    // private(set): schools variable, which is an instance property, is just only able to be set inside the class
    // but can still be accessed from outside the class
    @Published private(set) var schools: [School] = []
    @Published private(set) var error: DataError? = nil
    
    private let apiService: SchoolAPILogic
    
    init(apiService: SchoolAPILogic = SchoolAPI()) {
        self.apiService = apiService
    }
    
    // we would no longer need to use escaping closure as a callback because who interested in listening to schools
    // can suscribe to get the value of that variable
    func getSchools() {
        // we would use service in network layer
        apiService.getSchools { [weak self] result in
            switch result {
            case .success(let schools):
                self?.schools = schools ?? []
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
