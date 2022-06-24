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
        /*
         if let schoolAddress = schoolLocation{
             let coordinateString = schoolAddress.slice(start: "(", end: ")")
             let coordinates = coordinateString?.components(separatedBy: ",")
             if let coordinateArray = coordinates{
                 let latitude = (coordinateArray[0] as NSString).doubleValue
                 let longitude = (coordinateArray[1] as NSString).doubleValue
                 return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                        longitude: CLLocationDegrees(longitude))
             }
         }

         guard schoolLocation != nil else {
             let schoolAddress = schoolLocation
             let coordinateArray = schoolAddress!.slice(start: "(", end: ")")?.components(separatedBy: ",")
             let schoolLatitude = (coordinateArray![0] as NSString).doubleValue
             let schoolLongitude = (coordinateArray![1] as NSString).doubleValue
             return CLLocationCoordinate2D(latitude: CLLocationDegrees(schoolLatitude),
                                           longitude: CLLocationDegrees(schoolLongitude))
         }
         */
        if let schoolAddress = location {
            let coordinateString = schoolAddress.slice(start: "(", end: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates {
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                              longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
}
