//
//  SchoolTableViewCell.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/14/22.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    static let identifier = "SchoolTableViewCell"

    @IBOutlet weak private var schoolNameLabel: UILabel?
    @IBOutlet weak private var cityLabel: UILabel?

    var school: SchoolModel? {
        didSet {
            schoolNameLabel?.text = school?.schoolName
        }
    }
}
