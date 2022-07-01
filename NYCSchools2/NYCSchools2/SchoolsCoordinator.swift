//
//  SchoolsCoordinator.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/29/22.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}
class SchoolsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    var schoolsDataManager = SchoolsDataManager()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showSchoolsList()
    }
    func coordinateToDetails() {
        // let schoolDetailsVM = SchoolListDetailViewModel()
        let schoolListDetailVC = SchoolListDetailViewController()
        navigationController.pushViewController(schoolListDetailVC, animated: false)
    }
    private func showSchoolsList() {

        let storyboard = UIStoryboard(name: "SchoolListViewController", bundle: nil)
        let schoolListViewController = storyboard.instantiateViewController(withIdentifier: "SchoolsListViewController")
        let viewModel = SchoolListViewModel(dataManager: SchoolsDataManager())
        /*
        viewModel.endClosure = { action in
            switch action {
            case .
            }
        }
         */
        guard let schoolsListViewController = schoolListViewController as? SchoolListViewController else {
            fatalError("Unable to instantiate School List View Controller")
        }
        schoolsListViewController.schoolListViewModel = viewModel
        navigationController.viewControllers = [schoolsListViewController]
    }
}
