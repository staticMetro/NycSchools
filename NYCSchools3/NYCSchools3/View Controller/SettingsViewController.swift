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
    private let sortBy = UILabel()
    private let ascendDescend = UILabel()
    private let distance = UILabel()
    private let radius = UILabel()
    private var radiusSlider = UISlider()
    private let sliderValue = UILabel()
    private let radiusValue1 = UILabel()
    private let radiusValue2 = UILabel()
    private let radiusValue3 = UILabel()
    private let sortBySegmentControl = UISegmentedControl()
    private let ascendSegmentControl = UISegmentedControl()
    private let distanceSegmentControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sort & Filter"
        confgureSettingsUI()
        setupConstraints()
        viewModel?.loadState(sortBySegmentControl)
        viewModel?.loadState(ascendSegmentControl)
        viewModel?.loadState(distanceSegmentControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func confgureSettingsUI() {
        setupLabels(sortBy, "Sort by", .systemGray6)
        setupLabels(ascendDescend, "Ascending / Descending", .systemGray6)
        setupLabels(distance, "Distance Measurment Unit", .systemGray6)
        setupLabels(radius, "Radius", .systemGray6)
        setupLabels(radiusValue1, "0")
        setupLabels(radiusValue2, "25")
        setupLabels(radiusValue3, "50")

        setupSegmentControl(sortBySegmentControl)
        sortBySegmentControl.tag = 0
        sortBySegmentControl.insertSegment(withTitle: "SAT Reading", at: 0, animated: true)
        sortBySegmentControl.insertSegment(withTitle: "SAT Math", at: 1, animated: true)
        sortBySegmentControl.insertSegment(withTitle: "SAT Writing", at: 2, animated: true)
        sortBySegmentControl.addTarget(self, action: #selector(segementChanged(sender:)), for: .valueChanged)

        setupSegmentControl(ascendSegmentControl)
        ascendSegmentControl.tag = 1
        ascendSegmentControl.insertSegment(withTitle: "Ascending", at: 0, animated: true)
        ascendSegmentControl.insertSegment(withTitle: "Descending", at: 1, animated: true)
        ascendSegmentControl.addTarget(self, action: #selector(segementChanged(sender:)), for: .valueChanged)

        setupSegmentControl(distanceSegmentControl)
        distanceSegmentControl.tag = 2
        distanceSegmentControl.insertSegment(withTitle: "Kms", at: 0, animated: true)
        distanceSegmentControl.insertSegment(withTitle: "Miles", at: 1, animated: true)
        distanceSegmentControl.addTarget(self, action: #selector(segementChanged(sender:)), for: .valueChanged)

        setUpRadiusSlider()
    }
    @objc func segementChanged(sender: UISegmentedControl) {
        viewModel?.saveState(sender)
        print(sender)
    }

    @objc func radiusSliderValueDidChange(sender: UISlider!) {
        // print("payback value: \(sender.value)")
        sliderValue.isEnabled = true
        sliderValue.text = "\(sender.value.rounded())" +
        " \(distanceSegmentControl.titleForSegment(at: distanceSegmentControl.selectedSegmentIndex) ?? "ERROR")"
        sliderValue.textColor = .systemBlue
        UserDefaults.standard.set(radiusSlider.value.rounded(), forKey: "radius")
    }
    func setupSegmentControl(_ segmentControl: UISegmentedControl) {
        segmentControl.backgroundColor = UIColor.systemBackground
        // segmentControl.layer.borderColor = UIColor.blue.cgColor
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.tintColor = .systemBlue
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = UIColor.systemBlue.cgColor

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for: .selected)
        view.addSubview(segmentControl)
    }
    func setupLabels(_ label: UILabel, _ string: String) {
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = string
    }
    func setupLabels(_ label: UILabel, _ string: String, _ color: UIColor) {
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGray
        label.lineBreakMode = .byWordWrapping
        label.text = string
        label.backgroundColor = color
    }
    func setUpRadiusSlider() {
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = 50
        radiusSlider.isContinuous = true
        radiusSlider.tintColor = UIColor.systemBlue
        radiusSlider.addTarget(self, action: #selector(radiusSliderValueDidChange(sender:)),
                               for: .valueChanged)
        radiusSlider.setValue(UserDefaults.standard.float(
            forKey: "radius"), animated: true)
        setupLabels(sliderValue, "Select a measurement unit and adjust the slider to your prefernce")
    }
    // swiftlint:disable all
    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()

        constraints.append(sortBy.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(sortBy.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(sortBy.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        constraints.append(sortBy.heightAnchor.constraint(equalToConstant: 40))
        sortBy.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortBy)

        constraints.append(sortBySegmentControl.topAnchor.constraint(equalTo: sortBy.bottomAnchor, constant: 25))
        constraints.append(sortBySegmentControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(sortBySegmentControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100))
        constraints.append(sortBySegmentControl.heightAnchor.constraint(equalToConstant: 45))
        sortBySegmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortBySegmentControl)

        constraints.append(ascendDescend.topAnchor.constraint(equalTo: sortBySegmentControl.bottomAnchor, constant: 30))
        constraints.append(ascendDescend.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(ascendDescend.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        constraints.append(ascendDescend.heightAnchor.constraint(equalToConstant: 40))
        ascendDescend.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ascendDescend)

        constraints.append(ascendSegmentControl.topAnchor.constraint(equalTo: ascendDescend.bottomAnchor, constant: 25))
        constraints.append(ascendSegmentControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(ascendSegmentControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100))
        constraints.append(ascendSegmentControl.heightAnchor.constraint(equalToConstant: 45))
        ascendSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ascendSegmentControl)

        constraints.append(distance.topAnchor.constraint(equalTo: ascendSegmentControl.bottomAnchor, constant: 25))
        constraints.append(distance.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(distance.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        constraints.append(distance.heightAnchor.constraint(equalToConstant: 40))
        distance.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distance)

        constraints.append(distanceSegmentControl.topAnchor.constraint(equalTo: distance.bottomAnchor, constant: 25))
        constraints.append(distanceSegmentControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(distanceSegmentControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100))
        constraints.append(distanceSegmentControl.heightAnchor.constraint(equalToConstant: 45))
        distanceSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceSegmentControl)

        constraints.append(radius.topAnchor.constraint(equalTo: distanceSegmentControl.bottomAnchor, constant: 25))
        constraints.append(radius.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(radius.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        constraints.append(radius.heightAnchor.constraint(equalToConstant: 40))
        radius.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radius)

        constraints.append(radiusSlider.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: 30))
        constraints.append(radiusSlider.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(radiusSlider.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100))
        constraints.append(radiusSlider.heightAnchor.constraint(equalToConstant: 40))
        radiusSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusSlider)

        constraints.append(radiusValue1.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: 10))
        constraints.append(radiusValue1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(radiusValue1.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -100))
        constraints.append(radiusValue1.heightAnchor.constraint(equalToConstant: 40))
        radiusValue1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusValue1)

        constraints.append(radiusValue2.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: 10))
        constraints.append(radiusValue2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(radiusValue2.heightAnchor.constraint(equalToConstant: 40))
        radiusValue2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusValue2)

        constraints.append(radiusValue3.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: 10))
        constraints.append(radiusValue3.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -60))
        constraints.append(radiusValue3.heightAnchor.constraint(equalToConstant: 40))
        radiusValue3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusValue3)

        constraints.append(sliderValue.topAnchor.constraint(equalTo: radiusSlider.bottomAnchor, constant: 5))
        constraints.append(sliderValue.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(sliderValue.heightAnchor.constraint(equalToConstant: 40))
        constraints.append(sliderValue.widthAnchor.constraint(equalToConstant: 400))

        sliderValue.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderValue)
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable all

}
