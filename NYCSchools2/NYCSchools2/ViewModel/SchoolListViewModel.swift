//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation
import UIKit

protocol SchoolListViewModelProtocol: AnyObject {
    func fetchSchoolListSuccess(_ failedError: Error?)
    func fetchSATSuccess(_ failedError: Error?)
}

enum SchoolListExampleViewModelAction {
    case exit // for cancel button
    case details
}

class SchoolListViewModel {
    internal var schools: [SchoolModel] = []
    internal var filteredSchools: [SchoolModel] = []
    internal var satResults: [SATScoreModel] = []
    private let dataManager: SchoolsDataManager
    private weak var schoolListViewModelProtocol: SchoolListViewModelProtocol?
    var endClosure: ((SchoolListExampleViewModelAction) -> Void)?

    init(dataManager: SchoolsDataManager //
         // schoolListViewModelProtocol: SchoolListViewModelProtocol?
    ) {
        self.dataManager = dataManager
        // self.schoolListViewModelProtocol = schoolListViewModelProtocol
        fetchSchools()
    }
    func numberOfRows(inSection section: Int) -> Int {return schools.count}
    func data(forRowAt indexPath: IndexPath) -> SchoolModel {return schools[indexPath.row]}

    func fetchSchools() {
        dataManager.fetchData(
            urlString: APIURLS.fetchSchoolsLink) { [self] (resultData, fetchError) in
            guard fetchError != nil else {
                let error = fetchError
                schoolListViewModelProtocol?.fetchSchoolListSuccess(error)
                do {
                    // swiftlint:disable force_cast
                    let schoolsList = try JSONDecoder().decode([SchoolModel].self, from: resultData as! Data)
                    // swiftlint:enable force_cast
                    schools = schoolsList
                    filteredSchools = schools
                    fetchSATScores()
                } catch {
                    schoolListViewModelProtocol?.fetchSchoolListSuccess(error)
                }
                return
            }
        }
    }
    func fetchSATScores() {
        dataManager.fetchData(
            urlString: APIURLS.fetchSATScoresLink) { [self] (resultData, fetchError) in
            guard fetchError != nil else {
                let error = fetchError
                schoolListViewModelProtocol?.fetchSATSuccess(error)
                do {
                    // swiftlint:disable force_cast
                    let satScores = try JSONDecoder().decode([SATScoreModel].self, from: resultData as! Data)
                    // swiftlint:enable force_cast
                    mapSATScores(satScores)
                    schoolListViewModelProtocol?.fetchSchoolListSuccess(fetchError)
                    schoolListViewModelProtocol?.fetchSATSuccess(fetchError)
                } catch {
                    schoolListViewModelProtocol?.fetchSATSuccess(error)
                }
                return
            }
        }
    }
    func mapSATScores(_ satScoresList: [SATScoreModel]) {
        let previous = schools
        schools.removeAll()

        for schoolSATScore in satScoresList {
            if let dbn = schoolSATScore.dbn {
                var matchedSchool = previous.first(where: { (school) -> Bool in
                    return school.dbn == dbn
                })
                guard matchedSchool != nil else {
                    continue
                }
                matchedSchool?.satScores = schoolSATScore
                self.schools.append(matchedSchool!)
            }
        }
        // for loop that adds remaining schools that do not have sat scores to list
        // & provides explanation: "No score avialable. Please contact the school for more info"
    }
    func isFiltering(_ searchController: UISearchController) -> Bool {
        return searchController.isActive && !searchBarIsEmpty(searchController)
    }
    func searchBarIsEmpty(_ searchController: UISearchController)
    -> Bool {return searchController.searchBar.text?.isEmpty ?? true}

}
