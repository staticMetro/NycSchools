//
//  Extensions.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit

extension String {
    func slice(start: String, end: String) -> String? {
        return (range(of: start)?.upperBound).flatMap { substringFrom in
            (range(of: end, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
