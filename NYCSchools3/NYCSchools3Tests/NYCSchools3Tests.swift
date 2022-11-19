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
// swiftlint:disable all
    private var mockSchoolModel: [SchoolModel] = [SchoolModel(dbn: "27Q314", schoolName: "Epic High School - South", boro: "Q", location: "121-10 Rockaway Boulevard, South Ozone Park NY 11420", phoneNumber: "718-845-1290", faxNumber: "718-843-2072", schoolEmail: "info@epicschoolsnyc.org", website: "www.epicschoolsnyc.org", primaryAddress: "121-10 Rockaway Boulevard", city: "South Ozone Park", zip: "11420", stateCode: "NY", latitude: "40.67502", longitude: "-73.8167", borough: "QUEENS")]

    private var mockSATModel: [SATScoreModel] = [SATScoreModel(dbn: "27Q314", schoolName: "Epic High School - South", numOfTestTakers: "300", satReadingScore: "355", satMathScore: "404", satWritingScore: "363")]
    private var mockFilteredSchools : [SchoolModel] = []
// swiftlint:enable all 
    private lazy var schoolListViewModel: SchoolListViewModel = {
        var viewModel = SchoolListViewModel(schools: mockSchoolModel,
                                            satModel: mockSATModel, filteredSchools: mockFilteredSchools)
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
        var detailViewModel = SchoolListDetailViewModel(schoolModel: mockSchoolModel[0],
                                                        dataMnager: SchoolsDataManager())
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
        XCTAssertEqual(schoolListViewModel.numberOfSection(), 1)
    }

    func testNumberOfRows() {
        XCTAssertEqual(schoolListViewModel.numberOfRows(in: 0, isFiltering: false), 1)
        XCTAssertEqual(schoolListViewModel.numberOfRows(in: 0, isFiltering: true), 1)
    }

    func testHandleAction() {
        schoolListViewModel.handleAction(action: .exit)
        XCTAssertTrue(didSelectExit)
        schoolListViewModel.handleAction(action: .details(mockSchoolModel.first!))
        XCTAssertTrue(didSelectDetails)
    }
//    func testData() {
//        let result = viewModel.data(forRowAt: IndexPath, isFiltering: true)
//        XCTAssertNotNil(result)
//    }

    func testFilterContentForSearchText() {
        schoolListViewModel.filterContentForSearchText("High", scope: "All")
        XCTAssertEqual(schoolListViewModel.numberOfRows(in: 0, isFiltering: true), 1)

        schoolListViewModel.filterContentForSearchText("Low", scope: "All")
        XCTAssertEqual(schoolListViewModel.numberOfRows(in: 0, isFiltering: true), 0)
    }
    func testMapScores() {
        let mapped: () = schoolListViewModel.mapSATScores(schools: mockSchoolModel, satModel: mockSATModel)
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

    // LoadingViewModel Test Cases

    // MapViewModel Test Cases
    private var didSelectBack = false
    private var didSelectSettings = false

    private lazy var mapsViewModel: MapViewModel = {
        var mapsViewModel = MapViewModel()
        mapsViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.didSelectBack = true
            case .settings:
                // self?.navigationController.dismiss(animated: true)
                self?.didSelectSettings = true
            }
        }
        return mapsViewModel
    }()

    func testHandleActionMaps() {
        mapsViewModel.handleAction(action: .exit)
        XCTAssertTrue(didSelectBack)
        mapsViewModel.handleAction(action: .settings)
        XCTAssertTrue(didSelectSettings)
    }

    // ErrorViewModel Test Cases
    private var didSelectExitError = false

    private lazy var errorViewModel: ErrorViewModel = {
        var errorViewModel = ErrorViewModel()
        errorViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.didSelectExitError = true
            }
        }
        return errorViewModel
    }()

    func testHandleActionError() {
        errorViewModel.handleAction(action: .exit)
        XCTAssertTrue(didSelectExitError)
    }

    // SettingsViewModel Test Cases
    private var didSelectBackSettings = false
    private var mockSegmentState: SegmentedControlState = SegmentedControlState(selectedIndex: 0,
                                                                            titles: ["Sort By", "Asending", "distance"])
    private var mockSegmentControl: UISegmentedControl = UISegmentedControl(items: ["Sort By", "Asending", "distance"])
    // mockSegmentControl.selectedSegmentIndex = 0

    private lazy var settingsViewModel: SettingsViewModel = {
        var settingsViewModel = SettingsViewModel()
        settingsViewModel.endClosure = { [weak self] action in
            switch action {
            case .exit:
                self?.didSelectBackSettings = true
            }
        }
        return settingsViewModel
    }()

//    func testHandleActionErrorSettings() {
//        settingsViewModel.handleAction(action: .exit)
//        XCTAssertTrue(didSelectBackSettings)
//    }
//    func testSaveState() {
//        settingsViewModel.saveState(mockSegmentControl)
//        XCTAssertEqual(mockSegmentControl.selectedSegmentIndex, mockSegmentState.selectedIndex)
//    }
//    func testLoadState() {
//        settingsViewModel.loadState(mockSegmentControl)
//        XCTAssertEqual(mockSegmentState.selectedIndex, mockSegmentControl.selectedSegmentIndex)
//    }
}
