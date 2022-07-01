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
    @IBOutlet weak private var schoolNameLabel: UILabel!
    @IBOutlet weak private var readingSATScoreLabel: UILabel!
    @IBOutlet weak private var mathSATScoreLabel: UILabel!
    @IBOutlet weak private var writingLabel: UILabel!
    @IBOutlet weak private var addressLineLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var websiteLabel: UILabel!
    @IBOutlet weak private var phoneNumberLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var faxNumberLabel: UILabel!
    @IBOutlet weak private var mapView: MKMapView!
    private var schoolListDetailViewModel = SchoolListDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension SchoolListDetailViewController: SchoolListDetailViewModelProtocol {
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
        phoneNumberLabel.text = (school.phoneNumber)!
        emailLabel.text = school.schoolEmail
        faxNumberLabel.text = school.faxNumber
        Utilities.setLocation(school.location, mapView)
    }
}
