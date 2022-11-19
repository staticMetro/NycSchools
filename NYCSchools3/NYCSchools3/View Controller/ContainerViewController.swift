//
//  ContainerViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/20/22.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    func removeViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParent: nil)

            inActiveVC.view.removeFromSuperview()

            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParent()
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
