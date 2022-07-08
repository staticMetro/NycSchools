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
    func coordinateToSchoolsList() {
        let storyboard = UIStoryboard(name: "SchoolListViewController", bundle: nil)
        guard let schoolsListViewController = storyboard.instantiateViewController(
            withIdentifier: "SchoolsListViewController") as? SchoolListViewController else {
            fatalError("Unable to instantiate School List View Controller")
        }
        let viewModel = SchoolListViewModel(dataManager: SchoolsDataManager())
        viewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                break
            case .details(let model):
                self?.coordinateToSchoolDetails(model)
            }
        }
        schoolsListViewController.schoolListViewModel = viewModel
        navigationController.viewControllers = [schoolsListViewController]
    }
    func coordinateToSchoolDetails(_ schoolModel: SchoolModel) {
        let storyboard = UIStoryboard(name: "SchoolListDetailViewController", bundle: nil)
        guard let schoolListDetailViewController = storyboard.instantiateViewController(
            withIdentifier: "SchoolListDetailViewController") as? SchoolListDetailViewController else {
            fatalError("Unable to instantiate School Detail View Controller")
        }
        var detailsViewModel = SchoolListDetailViewModel(schoolModel: schoolModel, dataMnager: SchoolsDataManager())
        detailsViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.navigationController.popViewController(animated: true)
            }
        }
        schoolListDetailViewController.viewModel = detailsViewModel
        // schoolListDetailViewController.loadDetailView(schoolModel)
        navigationController.pushViewController(schoolListDetailViewController, animated: true)
        // schoolListDetailViewController.schoolNameLabel?.text = schoolModel.schoolName
    }
}
/* Tim: MVVM-C Example
 func start() {
     let viewModel = SchoolListExampleViewModel { [weak self] action in
         switch action {
         case .exit:
             // de
             break
         case .details:
             self?.coordinateToDetailsViewController()
         }
     }
     let vc = SchoolListExampleViewController(nibName: nil, bundle: nil)
     vc.viewModel = viewModel
     let nav = UINavigationController(rootViewController: vc)
 }

 protocol SchoolListExampleViewModelProtocol {
     func numberOfRowsInSection(in section: Int) -> Int
     func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
     func heightForRowAt(indexPath: IndexPath) -> CGFloat
     func didSelectRowAt(indexPath: IndexPath)
     func handleAction(action: SchoolListExampleViewModelAction)
 }
 enum SchoolListExampleViewModelAction {
     case exit // for cancel button
     case details
 }

 struct SchoolListExampleViewModel: SchoolListExampleViewModelProtocol {
     var endClosure: ((SchoolListExampleViewModelAction) -> Void)?
     func numberOfRowsInSection(in section: Int) -> Int {
         <#code#>
     }
     func cellForRowAt(indexPath: IndexPath) -> UITableViewCell {
         <#code#>
     }
     func heightForRowAt(indexPath: IndexPath) -> CGFloat {f
         <#code#>
     }
     func didSelectRowAt(indexPath: IndexPath) {
     }
     func handleAction(action: SchoolListExampleViewModelAction) {
         endClosure?(action)
     }
 }
*/
