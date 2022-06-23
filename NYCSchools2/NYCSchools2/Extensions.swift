//
//  Extensions.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/23/22.
//

import Foundation

extension String {
    func slice(start: String, end: String) -> String? {
        return (range(of: start)?.upperBound).flatMap { substringFrom in
            (range(of: end, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
