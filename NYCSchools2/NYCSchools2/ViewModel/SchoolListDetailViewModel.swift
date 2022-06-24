//
//  SchoolListDetailViewModel.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/23/22.
//

import Foundation
import UIKit
import MapKit

protocol SchoolListDetailViewModelDelegate {
    func loadDetailView(_ school: SchoolModel)
}

struct SchoolListDetailViewModel {
    /*
     var schoolNameLabel: String
     var readingSATScoreLabel: String
     var writingLabel: String
     var mathSATScoreLabel: String
     var cityLabel: String
     var addressLineLabel: String
     var websiteLabel: String
     var phoneNumberLabel: String
     var emailLabel: String
     var faxNumberLabel: String

    mutating func loadDetailView(_ school: SchoolModel) {
        schoolNameLabel = school.school_name ?? ""

        if let readingScore = school.satScores?.sat_critical_reading_avg_score {
            readingSATScoreLabel = "SAT Average Reading Score - " + readingScore
        }
        if let writingScore = school.satScores?.sat_writing_avg_score {
            writingLabel = "SAT Average Writing Score - " + writingScore
        }
        if let mathsScore = school.satScores?.sat_math_avg_score {
            mathSATScoreLabel = "SAT Average Maths Score - " + mathsScore
        }
        if let city = school.city, let code = school.state_code, let zip = school.zip {
            cityLabel = "\(city), \(code), \(zip)"
        }
        addressLineLabel = school.primary_address_line_1 ?? ""
        websiteLabel = school.website ?? ""
        phoneNumberLabel = "Phone Number: " + (school.phone_number)!
        emailLabel = school.school_email ?? ""
        faxNumberLabel = school.fax_number ?? ""

        // GOES AFTER LOADVIEW in viewDidLoad
        // setLocation(school.location!)
        // Utilities.setLocation(school.location!, mapView)
    }
*/
    func fetchCoordinates(_ schoolLocation: String?) -> CLLocationCoordinate2D? {
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
        if let schoolAddress = schoolLocation {
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
