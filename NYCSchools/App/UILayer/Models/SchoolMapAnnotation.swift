//
//  SchoolMapAnnotation.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-03-03.
//

import Foundation
import MapKit

class SchoolMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String,
         coordinate: CLLocationCoordinate2D,
         subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
    
    
}
