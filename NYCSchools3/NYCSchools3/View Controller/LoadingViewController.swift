//
//  ViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/18/22.
//

import UIKit

class LoadingViewController: UIViewController {
    private let label = UILabel()
    private let loadingImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewSetup()
        addConstraints()
    }
    func loadingViewSetup() {
        label.text = "Loading ..."
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(label)
        loadingImageView.image = UIImage(named: "loading")
        view.addSubview(loadingImageView)
        loadingImageView.rotate()
        view.backgroundColor = .systemBackground
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()

        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        var aspectRatio: CGFloat = 0.0
        aspectRatio = (loadingImageView.image?.size.width ?? 0.0) / (loadingImageView.image?.size.height ?? 0.0)
// swiftlint:disable all
        constraints.append(loadingImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(loadingImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250))
        constraints.append(loadingImageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(loadingImageView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(loadingImageView.heightAnchor.constraint(equalTo: loadingImageView.widthAnchor, multiplier: 1/aspectRatio))

        constraints.append(label.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(label.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150))
        constraints.append(label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5))
        constraints.append(label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5))
// swiftlint:enable all
        NSLayoutConstraint.activate(constraints)
    }
}
