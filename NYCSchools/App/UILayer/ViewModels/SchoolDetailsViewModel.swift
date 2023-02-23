//
//  SchoolDetailsViewModel.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-21.
//

import Foundation

class SchoolDetailsViewModel {
    // can only be set from inside class
    private(set) var school: School
    private(set) var schoolSAT: SchoolSAT
    
    init(school: School, schoolSAT: SchoolSAT) {
        self.school = school
        self.schoolSAT = schoolSAT
    }
}
