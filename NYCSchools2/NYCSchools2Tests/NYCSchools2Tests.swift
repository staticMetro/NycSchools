//
//  NYCSchools2Tests.swift
//  NYCSchools2Tests
//
//  Created by Lin, Tim on 7/12/22.
//

import XCTest
@testable import NYCSchools2

class NYCSchools2Tests: XCTestCase {

    private var didSelectExit: Bool = false
    private var didSelectDetails: Bool = false

    private var mockSchoolModel: [SchoolModel] = [SchoolModel(dbn: "27Q314", schoolName: "Epic High School - South", boro: "Q", location: "121-10 Rockaway Boulevard, South Ozone Park NY 11420", phoneNumber: "718-845-1290", faxNumber: "718-843-2072", schoolEmail: "info@epicschoolsnyc.org", website: "www.epicschoolsnyc.org", primaryAddress: "121-10 Rockaway Boulevard", city: "South Ozone Park", zip: "11420", stateCode: "NY", latitude: "40.67502", longitude: "-73.8167", borough: "QUEENS")]

    private var mockSATModel: [SATScoreModel] = [SATScoreModel(dbn: "27Q314", schoolName: "Epic High School - South", numOfTestTakers: "300", satReadingScore: "355", satMathScore: "404", satWritingScore: "363")]

    private lazy var viewModel: SchoolListViewModel = {
        let viewModel = SchoolListViewModel(schools: mockSchoolModel, satModel: mockSATModel)
        viewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.didSelectExit = true
            case .details:
                self?.didSelectDetails = true
            }
        }
        return viewModel
    }()

    func testNumberOfSection() {
        XCTAssertEqual(viewModel.numberOfSection(), 1)
    }

    func testNumberOfRows() {
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: false), 1)
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: true), 0)
    }

    func testHandleAction() {
        viewModel.handleAction(action: .exit)
        XCTAssertTrue(didSelectExit)
        viewModel.handleAction(action: .details(mockSchoolModel.first!))
        XCTAssertTrue(didSelectDetails)
    }

    func testFilterContentForSearchText() {
        viewModel.filterContentForSearchText("High")
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: true), 1)

        viewModel.filterContentForSearchText("Low")
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: true), 0)
    }
}
