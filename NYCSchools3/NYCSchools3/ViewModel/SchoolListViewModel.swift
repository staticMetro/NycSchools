//
//  SchoolListViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit

protocol SchoolListViewModelProtocol {
    func numberOfSection() -> Int
    func numberOfRows(in section: Int, isFiltering: Bool) -> Int
    func data(forRowAt indexPath: IndexPath, isFiltering: Bool) -> SchoolModel
    func filterContentForSearchText(_ searchText: String, scope: String)
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

struct SchoolListViewModel: SchoolListViewModelProtocol {
    private var schools: [SchoolModel]
    private var satModel:[SATScoreModel]
    private var filteredSchools: [SchoolModel]
    var endClosure: ((SchoolListViewModelAction) -> Void)?

    init(schools: [SchoolModel], satModel: [SATScoreModel], filteredSchools: [SchoolModel]) {
        self.satModel = satModel
        self.schools = schools
        self.filteredSchools = schools
        // self.schools = mapSATScores(schools: schools, satModel: satModel)
    }

    func handleAction(action: SchoolListViewModelAction) {
        endClosure?(action)
    }
    func numberOfSection() -> Int {
        //
        return 1
    }

    func numberOfRows(in section: Int, isFiltering: Bool) -> Int {
        //
        return isFiltering ? filteredSchools.count : schools.count
    }

    func data(forRowAt indexPath: IndexPath, isFiltering: Bool) -> SchoolModel {
        //
        return isFiltering ? filteredSchools[indexPath.row] : schools[indexPath.row]
    }
    func mapSATScores(schools: [SchoolModel], satModel: [SATScoreModel]) -> [SchoolModel] {
        var result: [SchoolModel] = []

        for schoolSATScore in satModel {
            if let dbn = schoolSATScore.dbn {
                guard var matchedSchool = schools.first(where: { (school) -> Bool in
                    return school.dbn == dbn
                }) else { continue }

                matchedSchool.satScores = schoolSATScore
                result.append(matchedSchool)
            }
        }
        for schoolMissing in schools {
            if !result.contains(where: { $0.schoolName == schoolMissing.schoolName }) {
                result.append(schoolMissing)
            }
        }
        return result
    }
     func filterContentForSearchText(_ searchText: String, scope: String) {
         _ = schools.filter {( school: SchoolModel) -> Bool in
            let boroughMatch = (scope == "All") || (school.borough?.localizedCapitalized.contains(scope) ?? false)
            let schoolMatch = school.schoolName?.lowercased().contains(searchText.lowercased()) ?? false
            if searchText.isEmpty {
                return boroughMatch
            }
            return boroughMatch && schoolMatch
        }
    }
}
