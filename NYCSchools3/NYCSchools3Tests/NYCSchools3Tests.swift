//
//  NYCSchools3Tests.swift
//  NYCSchools3Tests
//
//  Created by Aimeric Tshibuaya on 7/25/22.
//

import XCTest
@testable import NYCSchools3

class NYCSchools3Tests: XCTestCase {

    private var didSelectExit: Bool = false
    private var didSelectDetails: Bool = false

    private var mockSchoolModel: [SchoolModel] = [SchoolModel(dbn: "27Q314", schoolName: "Epic High School - South", boro: "Q", location: "121-10 Rockaway Boulevard, South Ozone Park NY 11420", phoneNumber: "718-845-1290", faxNumber: "718-843-2072", schoolEmail: "info@epicschoolsnyc.org", website: "www.epicschoolsnyc.org", primaryAddress: "121-10 Rockaway Boulevard", city: "South Ozone Park", zip: "11420", stateCode: "NY", latitude: "40.67502", longitude: "-73.8167", borough: "QUEENS")]

    private var mockSATModel: [SATScoreModel] = [SATScoreModel(dbn: "27Q314", schoolName: "Epic High School - South", numOfTestTakers: "300", satReadingScore: "355", satMathScore: "404", satWritingScore: "363")]
    private var mockFilteredSchools : [SchoolModel] = []

    private lazy var viewModel: SchoolListViewModel = {
        var viewModel = SchoolListViewModel(schools: mockSchoolModel, satModel: mockSATModel, filteredSchools: mockFilteredSchools)
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
    private lazy var detailViewModel: SchoolListDetailViewModel = {
        var detailViewModel = SchoolListDetailViewModel(schoolModel: mockSchoolModel[0])
        detailViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.didSelectExit = true
            }
        }
        return detailViewModel
    }()

    // SchoolLIstViewModel Test Cases
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
//    func testData() {
//        let result = viewModel.data(forRowAt: IndexPath, isFiltering: true)
//        XCTAssertNotNil(result)
//    }

    func testFilterContentForSearchText() {
        viewModel.filterContentForSearchText("High", scope: "All")
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: true), 1)

        viewModel.filterContentForSearchText("Low", scope: "All")
        XCTAssertEqual(viewModel.numberOfRows(in: 0, isFiltering: true), 0)
    }
    func testMapScores() {
        let mapped = viewModel.mapSATScores(schools: mockSchoolModel, satModel: mockSATModel)
        XCTAssertNotNil(mapped)
    }

    // SchoolListDetailViewModel Test Cases
    func testHandleActionDetails() {
        detailViewModel.handleAction(action: .exit)
        XCTAssert(didSelectExit)
    }
    func testGetConfiguration() {
        let config = detailViewModel.getConfiguration()
        XCTAssertNotNil(config)
    }
}
