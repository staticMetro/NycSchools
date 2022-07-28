//
//  SATScoreModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation

struct SATScoreModel: Codable {
    let dbn: String?
    let schoolName: String?
    let numOfTestTakers: String?
    let satReadingScore: String?
    let satMathScore: String?
    let satWritingScore: String?

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numOfTestTakers = "num_of_sat_test_takers"
        case satReadingScore = "sat_critical_reading_avg_score"
        case satMathScore = "sat_math_avg_score"
        case satWritingScore = "sat_writing_avg_score"
    }
}
