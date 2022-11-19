//
//  SettingsViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/26/22.
//

import Foundation
import UIKit

protocol SettingsViewModelProtocol {
    func handleAction(action: SettingsViewModelAction)
    func saveState(_ segmentedControl: UISegmentedControl)
    func loadState(_ segmentedControl: UISegmentedControl)
}

enum SettingsViewModelAction {
    case exit(Bool)
}
struct SegmentedControlState: Codable {
    let selectedIndex: Int
    let titles: [String]
}

struct SettingsViewModel: SettingsViewModelProtocol {
    var endClosure: ((SettingsViewModelAction) -> Void)?

    func handleAction(action: SettingsViewModelAction) {
        endClosure?(action)
    }

    func saveState(_ segmentedControl: UISegmentedControl) {
        let state = SegmentedControlState(
            selectedIndex: segmentedControl.selectedSegmentIndex,
            titles: (0..<segmentedControl.numberOfSegments).map {
                segmentedControl.titleForSegment(at: $0) ?? ""})
        // swiftlint:disable all

        let segmentList = try! PropertyListEncoder().encode(state)
        var key: String = ""
        if segmentedControl.tag == 0 {
            key = "SegmentedControlStateForSort"
        } else if segmentedControl.tag == 1 {
            key = "SegmentedControlStateForAsecnding"
        } else if segmentedControl.tag == 2 {
            key = "SegmentedControlStateForDistance"
        }
        UserDefaults.standard.set(segmentList, forKey: key)
    }
    func loadState(_ segmentedControl: UISegmentedControl) {
        var key: String = ""
        if segmentedControl.tag == 0 {
            key = "SegmentedControlStateForSort"
        } else if segmentedControl.tag == 1 {
            key = "SegmentedControlStateForAsecnding"
        } else if segmentedControl.tag == 2 {
            key = "SegmentedControlStateForDistance"
        }
        guard let segmentList = UserDefaults.standard.value(forKey: key) as? Data else { return }

        let state = try? PropertyListDecoder().decode(SegmentedControlState.self, from: segmentList)
        // swiftlint:enable all
        guard let statementTitle = state?.titles.enumerated() else {
            return
        }

        for element in statementTitle {
            segmentedControl.setTitle(element.element, forSegmentAt: element.offset)
        }

        segmentedControl.selectedSegmentIndex = state?.selectedIndex ?? 0
    }
}
