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

    @IBOutlet weak private var schoolNameLabel: UILabel?
    @IBOutlet weak private var readingSATScoreLabel: UILabel?
    @IBOutlet weak private var mathSATScoreLabel: UILabel?
    @IBOutlet weak private var writingLabel: UILabel?
    @IBOutlet weak private var addressLineLabel: UILabel?
    @IBOutlet weak private var cityLabel: UILabel?
    @IBOutlet weak private var websiteLabel: UILabel?
    @IBOutlet weak private var phoneNumberLabel: UILabel?
    @IBOutlet weak private var emailLabel: UILabel?
    @IBOutlet weak private var faxNumberLabel: UILabel?
    @IBOutlet weak private var mapView: MKMapView?
    var schoolListDetailViewModel: SchoolListDetailViewModelProtocol?
    var schoolClosure: ((SchoolListViewModelAction) -> SchoolModel)?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didSelectBackButton))
    }

    @objc func didSelectBackButton() {
        schoolListDetailViewModel?.handleAction(action: .exit)
    }

    // func loadDetailView(_ school: SchoolModel) {
    func loadDetailView(_ schoolClosure: SchoolModel) {
        schoolNameLabel?.text = schoolClosure.schoolName
        if let readingScore = schoolClosure.satScores?.satReadingScore {
            readingSATScoreLabel?.text = "SAT Average Reading Score - " + readingScore
        }
        if let writingScore = schoolClosure.satScores?.satWritingScore {
            writingLabel?.text = "SAT Average Writing Score - " + writingScore
        }
        if let mathsScore = schoolClosure.satScores?.satMathScore {
            mathSATScoreLabel?.text = "SAT Average Maths Score - " + mathsScore
        }
        if let city = schoolClosure.city, let code = schoolClosure.stateCode, let zip = schoolClosure.zip {
            cityLabel?.text = "\(city), \(code), \(zip)"
        }
        addressLineLabel?.text = schoolClosure.primaryAddress
        websiteLabel?.text = schoolClosure.website
        phoneNumberLabel?.text = (schoolClosure.phoneNumber)
        emailLabel?.text = schoolClosure.schoolEmail
        faxNumberLabel?.text = schoolClosure.faxNumber
        Utilities.setLocation(schoolClosure.location, mapView)
    }
}
