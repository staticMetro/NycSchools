//
//  SchoolTableViewCell.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/14/22.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    static let identifier = "SchoolTableViewCell"

    @IBOutlet weak var schoolNameLabel: UILabel?
    @IBOutlet weak var cityLabel: UILabel?

    var school: SchoolModel? {
        didSet {
            schoolNameLabel?.text = school?.schoolName
            // if let city = school.city, let code = school.state_code, let zip = school.zip{
               // cityLabel.text = "\(city), \(code), \(zip)"
            // }
        }
    }
}
