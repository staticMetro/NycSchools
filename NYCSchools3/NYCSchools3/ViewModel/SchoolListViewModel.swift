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
    func getSchools() -> [SchoolModel]
    func updateSchoolList()
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

class SchoolListViewModel: SchoolListViewModelProtocol {

    private var schools: [SchoolModel]
    private var satModel: [SATScoreModel]
    private var filteredSchools: [SchoolModel]
    var endClosure: ((SchoolListViewModelAction) -> Void)?

    init(schools: [SchoolModel], satModel: [SATScoreModel], filteredSchools: [SchoolModel]) {
        self.satModel = satModel
        self.schools = schools
        self.filteredSchools = schools
    }

    func handleAction(action: SchoolListViewModelAction) {
        endClosure?(action)
    }
    func getSchools() -> [SchoolModel] {
        return filteredSchools
    }
    func numberOfSection() -> Int {
        //
        return 1
    }

    func sortAscendDescend(_ flag: Bool) {
        var sortedSchools: [SchoolModel]
        if flag {
            sortedSchools = filteredSchools.sorted(by: {$0.schoolName ?? "" > $1.schoolName ?? ""})
        } else {
            sortedSchools = filteredSchools.sorted(by: {$0.schoolName ?? "" < $1.schoolName ?? ""})
        }
        filteredSchools = sortedSchools
    }
    func sortByMathScore() {
        var sortedSchools: [SchoolModel]
        sortedSchools = filteredSchools.sorted(
            by: {$0.satScores?.satMathScore ?? "" > $1.satScores?.satMathScore ?? ""})
        filteredSchools = sortedSchools
    }

    // if possible call in coordinator, after popping settings view, alternative: call in viewDidLoad
    func updateSchoolList() {
        let settingsValueSort = UserDefaults.standard.value(forKey: "SegmentedControlStateForSort")
        let settingsValueAD =  UserDefaults.standard.value(forKey: "SegmentedControlStateForAsecnding")
        let settingsValueDistance =  UserDefaults.standard.value(forKey: "SegmentedControlStateForDistance")

        guard settingsValueDistance != nil else {
            return
        }
        guard settingsValueAD != nil else {
            return
        }
        guard settingsValueSort != nil else {
            return
        }
        sortAscendDescend(true)
        sortByMathScore()
    }
    func numberOfRows(in section: Int, isFiltering: Bool) -> Int {
        //
        print(section)
        print(isFiltering)
        print(filteredSchools.count)
        print(schools.count)
        return isFiltering ? filteredSchools.count : schools.count
    }

    func data(forRowAt indexPath: IndexPath, isFiltering: Bool) -> SchoolModel {
        //
        return isFiltering ? filteredSchools[indexPath.row] : schools[indexPath.row]
    }

    func mapSATScores(schools: [SchoolModel], satModel: [SATScoreModel]) {
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
        self.schools = result
    }
    func filterContentForSearchText(_ searchText: String, scope: String) {
        filteredSchools = schools.filter {( school: SchoolModel) -> Bool in
            let boroughMatch = (scope == "All") || (school.borough?.localizedCapitalized.contains(scope) ?? false)
            let schoolMatch = school.schoolName?.lowercased().contains(searchText.lowercased()) ?? false
            if searchText.isEmpty {
                return boroughMatch
            }
            return boroughMatch && schoolMatch
        }
    }
}
