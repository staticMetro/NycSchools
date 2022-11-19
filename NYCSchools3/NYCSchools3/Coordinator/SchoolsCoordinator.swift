//
//  SchoolsCoordinator.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
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
    private var filteredSchools: [SchoolModel] = []
    private var containerViewController: ContainerViewController
    private let schoolViewController = SchoolListViewController(schoolsCellProvider: SchoolsCellProvider())

    init(navigationController: UINavigationController,
         dataManager: SchoolsDataManaging, containerViewController: ContainerViewController) {
        self.navigationController = navigationController
        self.dataManager = dataManager
        self.containerViewController = containerViewController
    }

    func start() {
        coordinateToLoadingView()
        let result = fetchData()
        switch result {
        case .success:
            DispatchQueue.main.async { [weak self] in
                self?.coordinateToSchoolsList()
            }
        case .timedOut:
            DispatchQueue.main.async { [weak self] in
                self?.coordinateToErrorView()
            }
        }
    }

    func fetchData() -> DispatchTimeoutResult {
        let group = DispatchGroup()

        group.enter()
        dataManager.fetchSchools { [weak self] status in
            switch status {
            case .initial, .loading:
                self?.coordinateToLoadingView()
            case .success(let schoolModel):
                group.leave()
                self?.schoolListModel = schoolModel
            case .failed:
                break
            }
        }

        group.enter()
        dataManager.fetchSAT { [weak self] status in
            switch status {
            case .initial, .loading:
                self?.coordinateToLoadingView()
            case .success(let satModel):
                group.leave()
                self?.satListModel = satModel
            case .failed:
                break
            }
        }
        return group.wait(timeout: DispatchTime.now() + 10)
    }
    func coordinateToLoadingView() {
        let viewController = LoadingViewController()
        containerViewController.removeViewController(inactiveViewController: viewController)
        containerViewController.addChild(viewController)
        containerViewController.removeFromParent()
        navigationController.viewControllers = [containerViewController.children[0]]
    }

    func coordinateToErrorView() {
        let viewController = ErrorViewController()
        containerViewController.removeViewController(inactiveViewController: viewController)
        containerViewController.addChild(viewController)
        containerViewController.removeFromParent()
        var viewModel = ErrorViewModel()
        viewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.start()
            }
        }
        viewController.viewModel = viewModel
        navigationController.viewControllers = [containerViewController.children[0]]
    }

    func coordinateToSchoolsList() {
        let viewModel = SchoolListViewModel(schools: schoolListModel,
                                            satModel: satListModel, filteredSchools: filteredSchools)
        viewModel.mapSATScores(schools: schoolListModel, satModel: satListModel)
        let mapViewController = MapViewController(schoolList: schoolViewController)
        var mapsViewModel = MapViewModel()

        viewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                break
            case .details(let model):
                self?.navigationController.dismiss(animated: true)
                self?.coordinateToSchoolDetails(model)
            }
        }
        mapsViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                break
            case .settings:
                self?.navigationController.dismiss(animated: true)
                self?.coordinateToSettings()
            }
        }
        mapViewController.viewModel = mapsViewModel
        schoolViewController.viewModel = viewModel
        navigationController.viewControllers = [mapViewController]
    }

    func coordinateToSchoolDetails(_ schoolModel: SchoolModel) {
        let schoolListDetailViewController = SchoolListDetailViewController()
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

    func coordinateToSettings() {
        let settingsViewController = SettingsViewController()
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.endClosure = {[weak self] action in
            guard let self = self else {
                return
            }
            switch action {
            case .exit:
                self.navigationController.popViewController(animated: true)
            }
        }
        settingsViewController.viewModel = settingsViewModel
        navigationController.pushViewController(settingsViewController, animated: true)
    }
}
