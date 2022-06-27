//
//  Extensions.swift
//  NYCSchools2
//
//  Created by Aimeric Tshibuaya on 6/23/22.
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
extension SchoolListViewController {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard let info = notification.userInfo,
                let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1) {
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    func isFiltering() -> Bool {return searchController.isActive && !searchBarIsEmpty()}
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}

    func filterContentForSearchText(_ searchText: String) {
        schoolListViewModel?.filteredSchools = (schoolListViewModel?.schools.filter({( school: SchoolModel) -> Bool in
            return school.schoolName!.lowercased().contains(searchText.lowercased())
        }))!
        tableView.reloadData()
    }
}
extension SchoolListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
        // if schoolListViewModel?.isFiltering(searchController) != nil {
            return schoolListViewModel?.filteredSchools.count ?? 0
        }
        return schoolListViewModel?.numberOfRows(inSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier) as! SchoolTableViewCell
        // swiftlint:enable force_cast
        if isFiltering() {
        // if schoolListViewModel?.isFiltering(searchController) != nil {
            cell.school = schoolListViewModel?.filteredSchools[indexPath.row]
        } else {
            cell.school = schoolListViewModel!.data(forRowAt: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {return 32}
}

extension SchoolListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = schoolListViewModel!.data(forRowAt: indexPath)
        self.performSegue(withIdentifier: "mainToDetailSegue", sender: school)
    }
}

extension SchoolListViewController {
    func fetchSchoolListSuccess(_ failedError: Error?) {
        if let error = failedError {displayAlert(error)} else {
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
                activityIndicator.stopAnimating()
                activityIndicator.hidesWhenStopped = true
                activityView.isHidden = true
            }
        }
    }
    func fetchSATSuccess(_ failedError: Error?) {
        if let error = failedError {self.displayAlert(error)}
    }
}
