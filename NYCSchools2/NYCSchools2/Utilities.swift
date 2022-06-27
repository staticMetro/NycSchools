//
//  Utilities.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/22/22.
//

import Foundation
import UIKit
import MapKit

class Utilities {
    static func setLocation(_ location: String?, _ mapView: MKMapView!) {
        let schoolAnnotation = MKPointAnnotation()
        if let schoolCoordinate = fetchCoordinates(location) {
            schoolAnnotation.coordinate = schoolCoordinate
            mapView.addAnnotation(schoolAnnotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            let region = MKCoordinateRegion(center: schoolAnnotation.coordinate, span: span)
            let adjustRegion = mapView.regionThatFits(region)
            mapView.setRegion(adjustRegion, animated: true)
        }
    }

    static func fetchCoordinates(_ location: String?) -> CLLocationCoordinate2D? {
        guard let schoolAddress = location,
              let coordinateString = schoolAddress.slice(start: "(", end: ")") else {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(0),
                                          longitude: CLLocationDegrees(0))
        }
        let coordinateArray = (coordinateString.components(separatedBy: ","))
        let latitude = (coordinateArray[0] as NSString).doubleValue
        let longitude = (coordinateArray[1] as NSString).doubleValue
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                      longitude: CLLocationDegrees(longitude))
    }
}
