//
//  SchoolListDetailViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit
import MapKit

class SchoolListDetailViewController: UIViewController, UITextViewDelegate {

    var schoolNameLabel = UILabel()
    private var readingSATScoreLabel = UILabel()
    private var mathSATScoreLabel = UILabel()
    private var writingLabel = UILabel()
    private var addressLineLabel = UILabel()
    private var cityLabel = UILabel()
    private var websiteLabel = UILabel()
    private var websiteTextView = UITextView()
    private var phoneNumberLabel = UILabel()
    private var emailLabel = UILabel()
    private var faxNumberLabel = UILabel()
    private var mapView = MKMapView()
    var viewModel: SchoolListDetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        websiteTextView.delegate = self
        loadDetailView()
        title = (schoolNameLabel.text)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didSelectBackButton))
    }
    @objc func didSelectBackButton() {
        viewModel?.handleAction(action: .exit)
    }

    func loadDetailView() {
        guard let configuration = viewModel?.getConfiguration() else {
            return
        }
        schoolNameLabel.text = configuration.schoolName
        readingSATScoreLabel.text = "SAT Average Reading Score - " + (configuration.satReadingScore ?? "No Score available. Please reach out to the school for more info")
        writingLabel.text = "SAT Average Writing Score - " + (configuration.satWritingScore ?? "No Scores available. Please reach out to the school for more info")
        mathSATScoreLabel.text = "SAT Average Maths Score - " + (configuration.satMathScore ?? "No Scores available. Please reach out to the school for more info")

        if let city = configuration.city,
            let code = configuration.stateCode,
            let zip = configuration.zip {
            cityLabel.text = "\(city), \(code), \(zip)"
        }
        addressLineLabel.text = (configuration.primaryAddress ?? "ERROR") + " , " + (cityLabel.text ?? "ERROR")
        websiteLabel.text = "Website: " + (configuration.website ?? "")
        phoneNumberLabel.text = "Phone: " + (configuration.phoneNumber ?? "")
        emailLabel.text = "Email: " + (configuration.schoolEmail ?? "")
        faxNumberLabel.text = configuration.faxNumber
        Utilities.setLocation(configuration.location, mapView)

        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 100
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height-800

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        view.addSubview(mapView)

        let address = UILabel()
        address.frame = CGRect(x: 0, y: 225, width: view.frame.size.width, height: 25)
        address.text = "Address"
        address.font = .systemFont(ofSize: 20, weight: .bold)
        address.textColor = .systemGray5
        address.backgroundColor = .systemGray2
        view.addSubview(address)

        addressLineLabel.frame = CGRect(x: 10, y:250, width: view.frame.size.width, height: 30)
        addressLineLabel.font = .systemFont(ofSize: 15, weight: .light)
        address.textColor = .secondarySystemBackground
        addressLineLabel.numberOfLines = 0
        addressLineLabel.lineBreakMode = .byWordWrapping
        view.addSubview(addressLineLabel)

        let details = UILabel()
        details.frame = CGRect(x: 0, y: 275, width: view.frame.size.width, height: 25)
        details.text = "Details"
        details.font = .systemFont(ofSize: 20, weight: .bold)
        details.textColor = .gray
        details.backgroundColor = .lightGray
        view.addSubview(details)

        let attributedString = NSMutableAttributedString(string: websiteLabel.text ?? "")
        attributedString.addAttribute(.link, value: websiteLabel.text as Any, range: NSRange(location: 0, length: (websiteLabel.text! as NSString).length))

        websiteTextView.attributedText = attributedString
        websiteTextView.frame = CGRect(x: 10, y:300, width: view.frame.size.width, height: 50)
        websiteTextView.font = .systemFont(ofSize: 15)
        websiteTextView.isUserInteractionEnabled = true
        websiteTextView.isEditable = false
        websiteTextView.isSelectable = false
        websiteTextView.dataDetectorTypes = .link
        view.addSubview(websiteTextView)

        phoneNumberLabel.frame = CGRect(x: 10, y:350, width: view.frame.size.width, height: 50)
        phoneNumberLabel.font = .systemFont(ofSize: 15, weight: .light)
        phoneNumberLabel.numberOfLines = 0
        phoneNumberLabel.lineBreakMode = .byWordWrapping
        view.addSubview(phoneNumberLabel)
        phoneNumberLabel.layer.addWaghaBorder(edge: .bottom, color: UIColor.lightGray, thickness: 1)


        emailLabel.frame = CGRect(x: 10, y:400, width: view.frame.size.width, height: 50)
        emailLabel.font = .systemFont(ofSize: 15, weight: .light)
        emailLabel.numberOfLines = 0
        emailLabel.lineBreakMode = .byWordWrapping
        view.addSubview(emailLabel)
        emailLabel.layer.addWaghaBorder(edge: .top, color: UIColor.lightGray, thickness: 1)

    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
// https://medium.com/@puneetmaratha/add-border-to-the-label-a24d4485f932
extension CALayer {
    func addWaghaBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - 1, y: 0, width: 1, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
