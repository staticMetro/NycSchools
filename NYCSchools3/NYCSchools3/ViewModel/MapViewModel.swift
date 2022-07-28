//
//  MapViewModel.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/26/22.
//

import Foundation

protocol MapViewModelProtocol {
    func handleAction(action: SchoolListViewAction)
}

enum SchoolListViewAction {
    case exit
    case settings
}

struct MapViewModel: MapViewModelProtocol {
    var endClosure: ((SchoolListViewAction) -> Void)?
    func handleAction(action: SchoolListViewAction) {
        endClosure?(action)
    }
}
