//
//  School.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation

struct SchoolModel: Codable {
    let dbn: String?
    let schoolName: String?
    let boro: String?
    let location: String?
    let phoneNumber: String?
    let faxNumber: String?
    let schoolEmail: String?
    let website: String?
    let primaryAddress: String?
    let city: String?
    let zip: String?
    let stateCode: String?
    let latitude: String?
    let longitude: String?
    let borough: String?

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case boro
        case location
        case phoneNumber = "phone_number"
        case faxNumber = "fax_number"
        case schoolEmail = "school_email"
        case website
        case primaryAddress = "primary_address_line_1"
        case city
        case zip
        case stateCode = "state_code"
        case latitude
        case longitude
        case borough
    }

    var satScores: SATScoreModel?
}
