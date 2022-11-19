//
//  ErrorViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation

protocol ErrorViewModelProtocol {
    func handleAction(action: ErrorViewModelAction)
}

enum ErrorViewModelAction {
    case exit
}

struct ErrorViewModel: ErrorViewModelProtocol {
    func handleAction(action: ErrorViewModelAction) {
        endClosure?(action)
    }

    var endClosure: ((ErrorViewModelAction) -> Void)?
}
