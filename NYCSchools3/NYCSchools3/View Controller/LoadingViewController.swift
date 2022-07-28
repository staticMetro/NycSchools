//
//  ViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/18/22.
//

import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewSetup()
    }
    func loadingViewSetup() {
        let loadingImageView = UIImageView ()
        let label = UILabel()
        label.text = "Loading ..."
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.frame = CGRect(x: 155, y:430, width: 200, height: 200)

        loadingImageView.frame = CGRect(x: 155, y:300, width: 90, height: 180)
        loadingImageView.image = UIImage(named: "loading")
        loadingImageView.layer.cornerRadius = (loadingImageView.frame.height)/2
        view.addSubview(loadingImageView)
        view.addSubview(label)
        view.backgroundColor = .systemBackground
    }

}

