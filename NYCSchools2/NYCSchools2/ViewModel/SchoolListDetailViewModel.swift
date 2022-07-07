//
//  SchoolListDetailViewModel.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/23/22.
//

import Foundation
import UIKit
import MapKit

struct SchoolListDetailConfiguration {
    var schoolName: String?
    var numOfTestTakers: String?
    var satReadingScore: String?
    var satMathScore: String?
    var satWritingScore: String?
    var boro: String?
    var location: String?
    var phoneNumber: String?
    var faxNumber: String?
    var schoolEmail: String?
    var website: String?
    var primaryAddress: String?
    var city: String?
    var zip: String?
    var stateCode: String?
    var latitude: String?
    var longitude: String?
    var borough: String?
}

protocol SchoolListDetailViewModelProtocol {
    func handleAction(action: SchoolListDetailViewAction)
    func getConfiguration() -> SchoolListDetailConfiguration
}

enum SchoolListDetailViewAction {
    case exit
}

struct SchoolListDetailViewModel: SchoolListDetailViewModelProtocol {
    var endClosure: ((SchoolListDetailViewAction) -> Void)?

    private let dataMnager: SchoolsDataManager
    private let schoolModel: SchoolModel

    init(schoolModel: SchoolModel, dataMnager: SchoolsDataManager) {
        self.schoolModel = schoolModel
        self.dataMnager = dataMnager
    }

    func getConfiguration() -> SchoolListDetailConfiguration {
        SchoolListDetailConfiguration(schoolName: schoolModel.schoolName,
                                      numOfTestTakers: schoolModel.satScores?.numOfTestTakers,
                                      satReadingScore: schoolModel.satScores?.satReadingScore,
                                      satMathScore: schoolModel.satScores?.satMathScore,
                                      satWritingScore: schoolModel.satScores?.satWritingScore,
                                      boro: schoolModel.boro, location: schoolModel.location,
                                      phoneNumber: schoolModel.phoneNumber, faxNumber: schoolModel.faxNumber,
                                      schoolEmail: schoolModel.schoolEmail, website: schoolModel.website,
                                      primaryAddress: schoolModel.primaryAddress,
                                      city: schoolModel.city, zip: schoolModel.zip, stateCode: schoolModel.stateCode,
                                      latitude: schoolModel.latitude, longitude: schoolModel.longitude,
                                      borough: schoolModel.borough)
    }

    func handleAction(action: SchoolListDetailViewAction) {
        endClosure?(action)
    }
}
