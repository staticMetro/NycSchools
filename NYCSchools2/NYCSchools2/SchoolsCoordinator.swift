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
        coordinateToSchoolsList()
    }
    func coordinateToDetails() {
        let storyboard = UIStoryboard(name: "SchoolListDetailsViewController", bundle: nil)
        let schoolListDetailsViewController = storyboard.instantiateViewController(withIdentifier: "SchoolListDetailViewController")
        let detailsViewModel = SchoolListDetailViewModel()

        guard let schoolListDetailsViewController = schoolListDetailsViewController as? SchoolListDetailViewController else {
            fatalError("Unable to instantiate School List View Controller")
        }
        // schoolListDetailsViewController.schoolListDetailsViewModel = detailsViewModel
        navigationController.viewControllers.append(schoolListDetailsViewController)

    }
    private func coordinateToSchoolsList() {

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
