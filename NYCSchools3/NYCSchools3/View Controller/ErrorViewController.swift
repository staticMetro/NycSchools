//
//  ErrorViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit

class ErrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureErrorUI()
    }
    func configureErrorUI() {
        let errorImageView = UIImageView()
        let label = UILabel()
        let button = UIButton()

        label.text = "Ooops something went wrong! Please try again later."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.frame = CGRect(x: 65, y:330, width: 300, height: 200)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        errorImageView.image = UIImage(named: "error.pdf")
        errorImageView.frame = CGRect(x: 155, y:300, width: 90, height: 90)
        button.backgroundColor = .black
        button.setTitle("Try Again", for: .normal)
        button.frame = CGRect(x: 35, y:800, width: 350, height: 40)
        view.addSubview(button)
        view.addSubview(errorImageView)
        view.addSubview(label)
        view.backgroundColor = .systemBackground
    }
}
