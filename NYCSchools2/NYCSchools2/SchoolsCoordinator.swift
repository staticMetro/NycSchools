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

    func start() {
       // let schoolListProtocol = SchoolListViewModelDelegateProtocol
        let viewModel = SchoolListViewModel()
        let schoolListViewController = SchoolListViewController()
        schoolListViewController.schoolListViewModel = viewModel
        navController?.pushViewController(schoolListViewController, animated: true)
/*
        { [weak self] action in
            switch action {
            case .exit:
                // de
                break
            case .details:
                self?.coordinateToDetailsViewController()
            }
        }
 let schoolListViewController = SchoolListViewController()
 schoolListViewController.schoolListViewModel = viewModel
 window.rootViewController = schoolListViewController
 */

    }
    func coordinateToDetails() {
        // let schoolDetailsVM = SchoolListDetailViewModel()
        let schoolListDetailVC = SchoolListDetailViewController()
        navController?.pushViewController(schoolListDetailVC, animated: true)
    }
}
