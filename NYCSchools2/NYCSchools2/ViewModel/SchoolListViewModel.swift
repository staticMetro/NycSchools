//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation

protocol SchoolListViewControllerDelegate: AnyObject {
    func fetchSchoolListSuccess(_ failedError: Error?)
    func fetchSATSuccess(_ failedError: Error?)
    //func schoolListAccess()
}

class SchoolListViewModel {
    private var schools: [SchoolModel] = []
    private var satResults: [SATScoreModel] = []

    let schoolsDataManager = SchoolsDataManager()
    weak var schoolsListViewControllerDelegate: SchoolListViewControllerDelegate?

    init(_ schoolsListViewControllerDelegate: SchoolListViewControllerDelegate) {
        self.schoolsListViewControllerDelegate = schoolsListViewControllerDelegate
        self.fetchSchools()
    }
    func numberOfRows(inSection section: Int) -> Int {
        return schools.count
    }

    func data(forRowAt indexPath: IndexPath) -> SchoolModel {
        return schools[indexPath.row]
    }
    func fetchSchools(){
        schoolsDataManager.fetchData(urlString: APIURLS.fetchSchoolsLink) { (resultData, fetchError) in
            if let error = fetchError{
                self.schoolsListViewControllerDelegate?.fetchSchoolListSuccess(error)
            }else {
                do{
                    let schoolsList = try JSONDecoder().decode([SchoolModel].self, from: resultData as! Data)
                    self.schools = schoolsList
                    self.fetchSATScores()
                }catch{
                    self.schoolsListViewControllerDelegate?.fetchSchoolListSuccess(error)
                }
            }
        }
    }

    func fetchSATScores(){
        schoolsDataManager.fetchData(urlString: APIURLS.fetchSATScoresLink) { (resultData, fetchError) in
            if let error = fetchError{
                self.schoolsListViewControllerDelegate?.fetchSATSuccess(error)
            }else {
                do{
                    let satScores = try JSONDecoder().decode([SATScoreModel].self, from: resultData as! Data)
                    self.mapSATScores(satScores)
                    self.schoolsListViewControllerDelegate?.fetchSchoolListSuccess(fetchError)
                    self.schoolsListViewControllerDelegate?.fetchSATSuccess(fetchError)
                }catch{
                    self.schoolsListViewControllerDelegate?.fetchSATSuccess(error)
                }
            }
        }
    }

    func mapSATScores(_ satScoresList: [SATScoreModel]){
        let previous = self.schools
        self.schools.removeAll()

        for schoolSATScore in satScoresList{
            if let dbn = schoolSATScore.dbn{
                var matchedSchool = previous.first(where: { (School) -> Bool in
                    return School.dbn == dbn
                })

                guard matchedSchool != nil else{
                    continue
                }

                matchedSchool?.satScores = schoolSATScore
                self.schools.append(matchedSchool!)
            }
        }
    }
}
