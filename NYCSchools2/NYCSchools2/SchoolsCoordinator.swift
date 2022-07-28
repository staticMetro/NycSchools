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
    private let dataManager: SchoolsDataManaging
    private var schoolListModel: [SchoolModel] = []
    private var satListModel: [SATScoreModel] = []

    init(navigationController: UINavigationController, dataManager: SchoolsDataManaging) {
        self.navigationController = navigationController
        self.dataManager = dataManager
    }

    func start() {
        let result = fetchData()
        switch result {
        case .success:
            coordinateToSchoolsList()
        case .timedOut:
            debugPrint("Time Out...")
        }
    }

    func fetchData() -> DispatchTimeoutResult {
        let group = DispatchGroup()

        group.enter()
        dataManager.fetchSchools { [weak self] status in
            switch status {
            case .initial, .loading:
                break
            case .success(let schoolModel):
                group.leave()
                self?.schoolListModel = schoolModel
            case .failed(_):
                group.leave()
                break
            }
        }

        group.enter()
        dataManager.fetchSAT { [weak self] status in
            switch status {
            case .initial, .loading:
                break
            case .success(let satModel):
                group.leave()
                self?.satListModel = satModel
            case .failed(_):
                group.leave()
                break
            }
        }

        return group.wait(timeout: DispatchTime.now() + 10)
    }

    func coordinateToSchoolsList() {
        let viewController = SchoolListViewController(schoolsCellProvider: SchoolsCellProvider())
        let viewModel = SchoolListViewModel(schools: schoolListModel, satModel: satListModel)
        viewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                break
            case .details(let model):
                self?.coordinateToSchoolDetails(model)
            }
        }
        viewController.viewModel = viewModel
        navigationController.viewControllers = [viewController]
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
        navigationController.pushViewController(schoolListDetailViewController, animated: true)
    }
}
