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

    @IBOutlet weak var schoolNameLabel: UILabel?
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
    var viewModel: SchoolListDetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didSelectBackButton))
    }

    @objc func didSelectBackButton() {
        viewModel?.handleAction(action: .exit)
    }

    func loadDetailView(_ school: SchoolModel) {
        guard let configuration = viewModel?.getConfiguration() else { return }
        schoolNameLabel?.text = configuration.schoolName
        readingSATScoreLabel?.text = "SAT Average Reading Score - " + (configuration.satReadingScore ?? "error")
        writingLabel?.text = "SAT Average Writing Score - " + (configuration.satWritingScore ?? "error")
        mathSATScoreLabel?.text = "SAT Average Maths Score - " + (configuration.satMathScore ?? "error")

        if let city = configuration.city,
            let code = configuration.stateCode,
            let zip = configuration.zip {
            cityLabel?.text = "\(city), \(code), \(zip)"
        }
        addressLineLabel?.text = configuration.primaryAddress
        websiteLabel?.text = configuration.website
        phoneNumberLabel?.text = configuration.phoneNumber
        emailLabel?.text = configuration.schoolEmail
        faxNumberLabel?.text = configuration.faxNumber
        Utilities.setLocation(configuration.location, mapView)
    }
}
