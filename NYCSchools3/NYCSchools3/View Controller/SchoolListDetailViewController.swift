//
//  SchoolListDetailViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit
import MapKit
import SafariServices

class SchoolListDetailViewController: UIViewController, UITextViewDelegate {

    private var schoolNameLabel = UILabel()
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

    private var schoolDetails = UITableView()
    var sections: [String] = []
    var itemsInSections: [[String]] = [[], []]
    var urlArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadDetailView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didSelectBackButton))
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       title = (schoolNameLabel.text)
   }
    @objc func didSelectBackButton() {
        viewModel?.handleAction(action: .exit)
    }

    func loadDetailView() {
        guard let configuration = viewModel?.getConfiguration() else {
            return
        }
        schoolNameLabel.text = configuration.schoolName
        readingSATScoreLabel.text = "SAT Average Reading Score - " +
        (configuration.satReadingScore ?? "No Score available. Please reach out to the school for more info")
        writingLabel.text = "SAT Average Writing Score - " +
        (configuration.satWritingScore ?? "No Scores available. Please reach out to the school for more info")
        mathSATScoreLabel.text = "SAT Average Maths Score - " +
        (configuration.satMathScore ?? "No Scores available. Please reach out to the school for more info")

        if let city = configuration.city,
           let code = configuration.stateCode,
           let zip = configuration.zip {
            cityLabel.text = "\(city), \(code), \(zip)"
        }
        addressLineLabel.text = (configuration.primaryAddress ?? "ERROR") + " , " + (cityLabel.text ?? "ERROR")
        websiteLabel.text = "Website: " + (configuration.website ?? "")
        phoneNumberLabel.text = "Phone: " + (configuration.phoneNumber ?? "")
        emailLabel.text = "Email: " + (configuration.schoolEmail ?? "")
        Utilities.setLocation(configuration.location, mapView)
        urlArray.append("https://\(configuration.website ?? "")")
        urlArray.append("tel://\(configuration.phoneNumber ?? "")")
        urlArray.append("mailto://\(configuration.schoolEmail ?? "")")

        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 100
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height-800

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true

        setupDetails(addressLineLabel, 15, .light)
        setupDetails(phoneNumberLabel, 15, .light)
        setupDetails(emailLabel, 15, .light)
        setUpSchoolDetails()
    }
    // swiftlint:disable all
    func setUpSchoolDetails() {
        view.addSubview(schoolDetails)
        schoolDetails.dataSource = self
        schoolDetails.delegate = self

        schoolDetails.tableHeaderView = mapView
        schoolDetails.separatorStyle = .singleLine
        schoolDetails.separatorColor = .lightGray
        schoolDetails.separatorInset = .zero
        schoolDetails.sectionHeaderTopPadding = 0
        schoolDetails.tableHeaderView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        schoolDetails.topAnchor.constraint(equalTo: schoolDetails.tableHeaderView?.bottomAnchor ??
                                           view.safeAreaLayoutGuide.topAnchor).isActive = true

        schoolDetails.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400).isActive = true
        schoolDetails.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        schoolDetails.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        schoolDetails.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        schoolDetails.translatesAutoresizingMaskIntoConstraints = false

        itemsInSections[0].append(addressLineLabel.text ?? "ERROR")
        itemsInSections[1].append(websiteLabel.text ?? "Error")
        itemsInSections[1].append(phoneNumberLabel.text ?? "Error")
        itemsInSections[1].append(emailLabel.text ?? "Error")
        sections.append("Address")
        sections.append("Details")

        schoolDetails.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        schoolDetails.reloadData()

        view.addSubview(readingSATScoreLabel)
        view.addSubview(mathSATScoreLabel)
        view.addSubview(writingLabel)

        readingSATScoreLabel.topAnchor.constraint(equalTo: schoolDetails.bottomAnchor, constant: 10).isActive = true
        readingSATScoreLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        readingSATScoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        readingSATScoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        readingSATScoreLabel.translatesAutoresizingMaskIntoConstraints = false

        mathSATScoreLabel.topAnchor.constraint(equalTo: readingSATScoreLabel.bottomAnchor, constant: 10).isActive = true
        mathSATScoreLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        mathSATScoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mathSATScoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mathSATScoreLabel.translatesAutoresizingMaskIntoConstraints = false

        writingLabel.topAnchor.constraint(equalTo: mathSATScoreLabel.bottomAnchor, constant: 10).isActive = true
        writingLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        writingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        writingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        writingLabel.translatesAutoresizingMaskIntoConstraints = false

        setupDetails(readingSATScoreLabel, 15, .semibold)
        setupDetails(mathSATScoreLabel, 15, .semibold)
        setupDetails(writingLabel, 15, .semibold)
    }
//swiftlint:enable all
    func setupDetails(_ label: UILabel, _ size: CGFloat, _ weight: UIFont.Weight) {
        label.font = .systemFont(ofSize: size, weight: weight)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        view.addSubview(label)
    }

    func textView(_ textView: UITextView, shouldInteractWith url: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let thisURL = URL(string: "https://\(url.absoluteString)") else { return false }
        let safariViewController = SFSafariViewController(url: thisURL)
        present(safariViewController, animated: true, completion: nil)

//        if ((URL.scheme?.contains("mailto")) != nil){
//            // Handle emails here
//        } else if ((URL.scheme?.contains("tel")) != nil) {
//            // Handle phone numbers here
//        } else if (((URL.scheme?.contains("http")) != nil) || (URL.scheme?.contains("https")) != nil) {
//            // Handle links
//            let safariViewController = SFSafariViewController(url: URL)
//            present(safariViewController, animated: true, completion: nil)
//        } else {
//            // Handle anything else that has slipped through.
//            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
//        }

        return false
    }
}
extension SchoolListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInSections[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else {
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellIdentifier")
        }
        cell.textLabel?.text = itemsInSections[indexPath.section][indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0,
                                                                       width: tableView.bounds.width,
                                                                       height: tableView.sectionHeaderHeight))
        view.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.contentView.backgroundColor = .systemGray6
        view.contentView.tintColor = .systemGray
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = urlArray[indexPath.row]
        guard let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
