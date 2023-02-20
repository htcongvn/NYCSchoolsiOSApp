//
//  School.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-17.
//

import Foundation

struct School: Decodable {
    let dbn: String
    let schoolName: String?
    let overviewParagraph: String?
    let schoolEmail: String?
    let academicOpportunities1: String?
    let academicOpportunities2: String?
    let neighborhood: String?
    let phoneNumber: String?
    let website: String?
    let finalgrades: String?
    let totalStudents: String?
    let schoolSports: String?
    let primaryAddressLine: String?
    let city: String?
    let zip : String?
    let latitude: String?
    let longitude: String?
    
//    https://www.hackingwithswift.com/articles/119/codable-cheat-sheet
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case schoolEmail = "school_email"
        case academicOpportunities1 = "academicopportunities1"
        case academicOpportunities2 = "academicopportunities2"
        case neighborhood
        case phoneNumber = "phoneNumber"
        case website
        case finalgrades
        case totalStudents = "total_students"
        case schoolSports = "school_sports"
        case primaryAddressLine = "primary_address_line_1"
        case city
        case zip
        case latitude
        case longitude
    }
}
