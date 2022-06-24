//
//  SchoolListDetailViewController.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/14/22.
//

import Foundation
import UIKit
import MapKit

class SchoolListDetailViewController: UIViewController {

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var readingSATScoreLabel: UILabel!
    @IBOutlet weak var mathSATScoreLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    @IBOutlet weak var addressLineLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var faxNumberLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
   // @IBOutlet weak var navigateButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func loadDetailView(_ school: SchoolModel) {
        schoolNameLabel.text = school.schoolName
        if let readingScore = school.satScores?.satReadingScore {
            readingSATScoreLabel.text = "SAT Average Reading Score - " + readingScore
        }
        if let writingScore = school.satScores?.satWritingScore {
            writingLabel.text = "SAT Average Writing Score - " + writingScore
        }
        if let mathsScore = school.satScores?.satMathScore {
            mathSATScoreLabel.text = "SAT Average Maths Score - " + mathsScore
        }
        if let city = school.city, let code = school.stateCode, let zip = school.zip {
            cityLabel.text = "\(city), \(code), \(zip)"
        }
        addressLineLabel.text = school.primaryAddress
        websiteLabel.text = school.website
        phoneNumberLabel.text = "Phone Number: " + (school.phoneNumber)!
        emailLabel.text = school.schoolEmail
        faxNumberLabel.text = school.faxNumber
        Utilities.setLocation(school.location!, mapView)
    }
    func setLocation(_ location: String) {
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
    func fetchCoordinates(_ location: String?) -> CLLocationCoordinate2D?{
        if let schoolAddress = location{
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
