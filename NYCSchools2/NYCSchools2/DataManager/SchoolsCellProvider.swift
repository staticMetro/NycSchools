//
//  SchoolsCellProvider.swift
//  NYCSchools2
//
//  Created by Lin, Tim on 7/12/22.
//

import Foundation
import UIKit

protocol SchoolsCellProviding {
    func cellFor(data: SchoolModel, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

struct SchoolsCellProvider: SchoolsCellProviding {
    func cellFor(data: SchoolModel, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as? UITableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = data.schoolName
        return cell
    }
}
