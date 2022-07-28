//
//  SettingsViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/26/22.
//

import Foundation

protocol SettingsViewModelProtocol {
    func handleAction(action: SettingsViewAction)
}

enum SettingsViewAction {
    case exit
}

struct SettingsViewModel: SettingsViewModelProtocol {
    var endClosure: ((SettingsViewAction) -> Void)?

    func handleAction(action: SettingsViewAction) {
        endClosure?(action)
    }
}
