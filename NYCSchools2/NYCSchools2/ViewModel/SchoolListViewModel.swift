//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation

protocol SchoolListViewModelDelegateProtocol: AnyObject {
    func fetchSchoolListSuccess(_ failedError: Error?)
    func fetchSATSuccess(_ failedError: Error?)
}

class SchoolListViewModel {
    internal var schools: [SchoolModel] = []
    internal var filteredSchools: [SchoolModel] = []
    internal var satResults: [SATScoreModel] = []
    private var schoolsDataManager = SchoolsDataManager()
    private weak var schoolsListViewControllerDelegate: SchoolListViewModelDelegateProtocol?

    init(_ schoolsListViewControllerDelegate: SchoolListViewModelDelegateProtocol) {
        self.schoolsListViewControllerDelegate = schoolsListViewControllerDelegate
        fetchSchools()
    }
    func numberOfRows(inSection section: Int) -> Int {return schools.count}
    func data(forRowAt indexPath: IndexPath) -> SchoolModel {return schools[indexPath.row]}

    func fetchSchools() {
        schoolsDataManager.fetchData(urlString: APIURLS.fetchSchoolsLink) { [self] (resultData, fetchError) in
            guard fetchError != nil else {
                let error = fetchError
                schoolsListViewControllerDelegate?.fetchSchoolListSuccess(error)
                do {
                    // swiftlint:disable force_cast
                    let schoolsList = try JSONDecoder().decode([SchoolModel].self, from: resultData as! Data)
                    // swiftlint:enable force_cast
                    schools = schoolsList
                    fetchSATScores()
                } catch {
                    schoolsListViewControllerDelegate?.fetchSchoolListSuccess(error)
                }
                return
            }
        }
    }
    func fetchSATScores() {
        schoolsDataManager.fetchData(urlString: APIURLS.fetchSATScoresLink) { [self] (resultData, fetchError) in
            guard fetchError != nil else {
                let error = fetchError
                schoolsListViewControllerDelegate?.fetchSATSuccess(error)
                do {
                    // swiftlint:disable force_cast
                    let satScores = try JSONDecoder().decode([SATScoreModel].self, from: resultData as! Data)
                    // swiftlint:enable force_cast
                    mapSATScores(satScores)
                    schoolsListViewControllerDelegate?.fetchSchoolListSuccess(fetchError)
                    schoolsListViewControllerDelegate?.fetchSATSuccess(fetchError)
                } catch {
                    schoolsListViewControllerDelegate?.fetchSATSuccess(error)
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
    }
}
