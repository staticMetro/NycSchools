//
//  SchoolsCellProvider.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit

protocol SchoolsCellProviding {
    func cellFor(data: SchoolModel, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

struct SchoolsCellProvider: SchoolsCellProviding {
    func cellFor(data: SchoolModel, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()
        content.text = data.schoolName
        guard let index = data.location?.firstIndex(of: "(") else {
            return UITableViewCell()
        }
        content.secondaryText = String(data.location?[..<(index)] ?? "")
        let boro = data.boro?.lowercased()
        var imageName: String = ""

        switch boro {
        case "k":
            imageName = "brooklyn.pdf"
        case "m":
            imageName = "manhattan.pdf"
        case "x":
            imageName = "bronx.pdf"
        case "q":
            imageName = "queens.pdf"
        case "r":
            imageName = "statenIsland.pdf"
        default: break
        }
        content.image = UIImage(named: imageName)
        cell.contentConfiguration = content
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height ?? 0)/2
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
