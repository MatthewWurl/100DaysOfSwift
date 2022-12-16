//
//  Capital.swift
//  CapitalCities
//
//  Created by Matt X on 12/14/22.
//

import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var wikiUrl: URL
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, wikiUrl: URL) {
        self.title = title
        self.coordinate = coordinate
        self.wikiUrl = wikiUrl
    }
}
