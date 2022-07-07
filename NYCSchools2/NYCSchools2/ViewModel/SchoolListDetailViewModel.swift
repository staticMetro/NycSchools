//
//  SchoolListDetailViewModel.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/23/22.
//

import Foundation
import UIKit
import MapKit

protocol SchoolListDetailViewModelProtocol {
    func loadDetailView(_ school: SchoolModel)
    func handleAction(action: SchoolListDetailViewAction)
}

enum SchoolListDetailViewAction {
    case exit
}

struct SchoolListDetailViewModel: SchoolListDetailViewModelProtocol {
    var endClosure: ((SchoolListDetailViewAction) -> Void)?

    var dataMnager: SchoolsDataManager

    func loadDetailView(_ school: SchoolModel) {
        // ..
    }

    func handleAction(action: SchoolListDetailViewAction) {
        endClosure?(action)
    }
}
