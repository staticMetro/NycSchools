//
//  MapViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/26/22.
//

import Foundation

protocol MapViewModelProtocol {
    func handleAction(action: MapViewModelAction)
}

enum MapViewModelAction {
    case exit
    case settings
}

struct MapViewModel: MapViewModelProtocol {
    func handleAction(action: MapViewModelAction) {
        endClosure?(action)
    }

    var endClosure: ((MapViewModelAction) -> Void)?
}
