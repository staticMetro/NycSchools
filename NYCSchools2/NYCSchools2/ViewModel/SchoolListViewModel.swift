//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation
import UIKit

protocol SchoolListViewModelProtocol: AnyObject {
    func numberOfSection() -> Int
    func numberOfRows(in section: Int, isFiltering: Bool) -> Int
    func data(forRowAt indexPath: IndexPath, isFiltering: Bool) -> SchoolModel
    func filterContentForSearchText(_ searchText: String?)
    func handleAction(action: SchoolListViewModelAction)
}

enum SchoolListViewModelAction {
    case exit // for cancel button
    case details(SchoolModel) // for school details
}

enum SchoolListViewModelEvent {
    case loading
    case failure(Error)
    case success
}

enum SearchRegion: String, CaseIterable {
    case all = "All"
    case brooklyn = "Brooklyn"
    case manhattan = "Manhattan"
    case queens = "Queens"
    case bronx = "Bronx"
    case statenIsland = "Staten Island"
}

class SchoolListViewModel: SchoolListViewModelProtocol {
    private let schools: [SchoolModel]
    private let satModel: [SATScoreModel]
    private var filteredSchools: [SchoolModel] = []

    var endClosure: ((SchoolListViewModelAction) -> Void)?

    init(schools: [SchoolModel], satModel: [SATScoreModel]) {
        self.schools = schools
        self.satModel = satModel
    }

    func handleAction(action: SchoolListViewModelAction) {
        endClosure?(action)
    }

    func numberOfSection() -> Int {
        return 1
    }

    func numberOfRows(in section: Int, isFiltering: Bool) -> Int {
        return isFiltering ? filteredSchools.count : schools.count
    }

    func data(forRowAt indexPath: IndexPath, isFiltering: Bool) -> SchoolModel {
        return isFiltering ? filteredSchools[indexPath.row] : schools[indexPath.row]
    }

    func filterContentForSearchText(_ searchText: String?) {
        guard let text = searchText else { return }
        filteredSchools = schools.filter { $0.schoolName?.lowercased().contains(text.lowercased()) ?? false }
    }
}
