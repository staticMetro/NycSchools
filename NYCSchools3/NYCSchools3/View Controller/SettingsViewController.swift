//
//  SettingsViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/26/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModelProtocol?
    let sortBy = UILabel()
    let ascendDescend = UILabel()
    let distance = UILabel()
    let radius = UILabel()
    var radiusSlider = UISlider()
    let sortBySegmentControl = UISegmentedControl()
    let ascendSegmentControl = UISegmentedControl()
    let distanceSegmentControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sort & Filter"
        confgureSettingsUI()
    }
    func confgureSettingsUI() {

        sortBy.frame = CGRect(x: 10, y:225, width: view.frame.size.width, height: 50)
        sortBy.font = .systemFont(ofSize: 15, weight: .semibold)
        sortBy.numberOfLines = 0
        sortBy.lineBreakMode = .byWordWrapping
        sortBy.text = "Sort by"
        view.addSubview(sortBy)


        setupSegmentControl(sortBySegmentControl)
        sortBySegmentControl.insertSegment(withTitle: "SAT Score", at: 0, animated: true)
        sortBySegmentControl.insertSegment(withTitle: "Attendace", at: 1, animated: true)

        setupSegmentControl(ascendSegmentControl)
        ascendSegmentControl.insertSegment(withTitle: "Ascending", at: 0, animated: true)
        ascendSegmentControl.insertSegment(withTitle: "Descending", at: 1, animated: true)

        setupSegmentControl(distanceSegmentControl)
        distanceSegmentControl.insertSegment(withTitle: "Kms", at: 0, animated: true)
        distanceSegmentControl.insertSegment(withTitle: "Miles", at: 1, animated: true)

        sortBySegmentControl.frame = CGRect(x: 30, y: 100, width: view.frame.width - 200, height: 40)
        ascendSegmentControl.frame = CGRect(x: 30, y: 150, width: view.frame.width - 200, height: 40)
        distanceSegmentControl.frame = CGRect(x: 30, y: 200, width: view.frame.width - 200, height: 40)


        ascendDescend.frame = CGRect(x: 10, y:250, width: view.frame.size.width, height: 50)
        ascendDescend.font = .systemFont(ofSize: 15, weight: .semibold)
        ascendDescend.numberOfLines = 0
        ascendDescend.lineBreakMode = .byWordWrapping
        ascendDescend.text = "Ascending / Descending"
        view.addSubview(ascendDescend)


        distance.frame = CGRect(x: 10, y:275, width: view.frame.size.width, height: 50)
        distance.font = .systemFont(ofSize: 15, weight: .semibold)
        distance.numberOfLines = 0
        distance.lineBreakMode = .byWordWrapping
        distance.text = "Distance Measurement Unit"
        view.addSubview(distance)

        setUpRadiusSlider()
    }
    @objc func radiusSliderValueDidChange(sender: UISlider!)
    {
        print("payback value: \(sender.value)")
        radius.text = "\(sender.value)"
    }
    func setupSegmentControl(_ segmentControl: UISegmentedControl){
        segmentControl.backgroundColor = UIColor.white
        segmentControl.layer.borderColor = UIColor.blue.cgColor
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.layer.borderWidth = 1

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        view.addSubview(segmentControl)
    }
    func setUpRadiusSlider() {
        radius.frame = CGRect(x: 10, y:300, width: view.frame.size.width, height: 50)
        radius.font = .systemFont(ofSize: 15, weight: .semibold)
        radius.numberOfLines = 0
        radius.lineBreakMode = .byWordWrapping
        radius.text = "Radius"
        view.addSubview(radius)

        radiusSlider.frame = CGRect(x: 10, y: 100, width: view.frame.width - 100, height: 30)
        radiusSlider.center = view.center
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = 50
        radiusSlider.isContinuous = true
        radiusSlider.tintColor = UIColor.blue
        radiusSlider.value = 30
        radiusSlider.addTarget(self, action: #selector(radiusSliderValueDidChange(sender:)),for: .valueChanged)
        radiusSlider.setValue(radiusSlider.value, animated: true)
        view.addSubview(radiusSlider)
    }

}
