//
//  SchoolsCoordinator.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/29/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var navController: UINavigationController? {get set}
    func start()
}
class SchoolsCoordinator: Coordinator {
    internal var navController: UINavigationController?
    internal var schoolsDataManager = SchoolsDataManager()
    internal var rootViewController: UIViewController {
        return navController ?? UINavigationController()
    }

    func start() {
        showSchoolsList()
    }
    func coordinateToDetails() {
        // let schoolDetailsVM = SchoolListDetailViewModel()
        let schoolListDetailVC = SchoolListDetailViewController()
        navController?.pushViewController(schoolListDetailVC, animated: true)
    }
    func showSchoolsList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let schoolListViewController = storyboard.instantiateViewController(withIdentifier: "SchoolsListViewController")
        guard let schoolsListViewController = schoolListViewController as? SchoolListViewController else {
            fatalError("Unable to instantiate School List View Controller")
        }
        navController?.pushViewController(schoolsListViewController, animated: true)
    }
}
