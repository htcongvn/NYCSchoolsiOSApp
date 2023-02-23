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
    // Publishers declaration
    @Published private(set) var schools: [School]?
    @Published var schoolSATs: [SchoolSAT]?
    @Published private(set) var error: DataError? = nil
    
    private(set) var schoolSectionsList: [SchoolSection]?
    private(set) var schoolSATDictionary: [String: SchoolSAT] = [:] // key: dbn
    
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
                if schools?.isEmpty == false {
                    self?.prepareSchoolSections()
                }
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    func getSchoolSATs() {
        schoolSATs?.removeAll()
        
        apiService.getSchoolSATResults { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let schoolSATResults):
                if let schoolSATResults = schoolSATResults {
                    self.schoolSATs = schoolSATResults
                    for sat in schoolSATResults {
                        self.schoolSATDictionary[sat.dbn] = sat
                    }
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func prepareSchoolSections() {
        var listOfSections = [SchoolSection]()
        var schoolDictionary = [String: SchoolSection]()
        
        guard let schools = schools else {
            return
        }
        
        for school in schools {
            if let city = school.city {
                if schoolDictionary[city] != nil {
                    schoolDictionary[city]?.schools.append(school)
                } else {
                    var newSection = SchoolSection(city: city, schools: [])
                    newSection.schools.append(school)
                    schoolDictionary[city] = newSection
                }
            }
        }
        
        listOfSections = Array(schoolDictionary.values)
//        listOfSections.sort { section1, section2 in
//            return section1.city < section2.city
//        }
        listOfSections.sort {
            return $0.city < $1.city
        }
        schoolSectionsList = listOfSections
    }
}
