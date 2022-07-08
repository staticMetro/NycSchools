//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import UIKit
import MapKit

class SchoolListViewController: UIViewController, SchoolListViewModelProtocol {

    @IBOutlet weak internal var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak internal var activityIndicator: UIActivityIndicatorView!
    var schoolListViewModel: SchoolListViewModel?
    // var viewModel: SchoolListViewModelProtocol?
    var searchController = UISearchController(searchResultsController: nil)
    var searchFooterBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NYC Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
        activityIndicator.startAnimating()
        searchBarSetup()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
    }
    func handleAction(action: SchoolListViewModelAction) {
        schoolListViewModel?.endClosure?(action)
    }
    func searchBarSetup() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search NYC High Schools"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Brooklyn",
                                                        "Manhattan", "Queens", "Bronx", "Staten Island"]
    }

    // Function to throw alert.
    func displayAlert(_ error: Error) {
            print("Error while fetching Schools.")
            print(error.localizedDescription)
    }
}

extension SchoolListViewController: UISearchResultsUpdating {
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
    // Modify search functions for scope
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
    func filterContentForSearchText(_ searchText: String) {
        schoolListViewModel?.filteredSchools = (schoolListViewModel?.schools.filter({( school: SchoolModel) -> Bool in
            return school.schoolName?.lowercased().contains(searchText.lowercased()) ?? false
        }))!
        tableView.reloadData()
    }
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "")
    }
}
extension SchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schoolListViewModel?.isFiltering(searchController) != false {
            return schoolListViewModel?.filteredSchools.count ?? 0
        }
        return schoolListViewModel?.numberOfRows(inSection: section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier) as! SchoolTableViewCell
        // swiftlint:enable force_cast
        if schoolListViewModel?.isFiltering(searchController) != false {
            cell.school = schoolListViewModel?.filteredSchools[indexPath.row]
        } else {
            cell.school = schoolListViewModel?.data(forRowAt: indexPath)
        }
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {return 64}
}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school: SchoolModel?
        if schoolListViewModel?.isFiltering(searchController) != false {
            school = schoolListViewModel?.filteredSchools[indexPath.row]
        } else {
            school = schoolListViewModel?.data(forRowAt: indexPath)
        }
        guard let model = school else { return }
        schoolListViewModel?.handleAction(action: .details(model))
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
    func fetchSATSuccess(_ failedError: Error?) {if let error = failedError {self.displayAlert(error)}}
}

/* Tim: MVVM-C Example
 protocol SchoolListExampleViewModelProtocol {
     func numberOfRowsInSection(in section: Int) -> Int
     func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
     func heightForRowAt(indexPath: IndexPath) -> CGFloat
     func didSelectRowAt(indexPath: IndexPath)
     func handleAction(action: SchoolListExampleViewModelAction)
 }
 enum SchoolListExampleViewModelAction {
     case exit // for cancel button
     case details
 }

 struct SchoolListExampleViewModel: SchoolListExampleViewModelProtocol {
     var endClosure: ((SchoolListExampleViewModelAction) -> Void)?
     func numberOfRowsInSection(in section: Int) -> Int {
         <#code#>
     }
     func cellForRowAt(indexPath: IndexPath) -> UITableViewCell {
         <#code#>
     }
     func heightForRowAt(indexPath: IndexPath) -> CGFloat {f
         <#code#>
     }
     func didSelectRowAt(indexPath: IndexPath) {
     }
     func handleAction(action: SchoolListExampleViewModelAction) {
         endClosure?(action)
     }
 }
 class SchoolListExampleViewController: UIViewController {
     var viewModel: SchoolListExampleViewModelProtocol?
     func exit() {
         viewModel?.handleAction(action: .exit)
     }
     func goToDetails() {
         viewModel?.handleAction(action: .details)
     }
 }
 extension SchoolListExampleViewController: UITableViewDelegate {
 }
 extension SchoolListExampleViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel?.numberOfRowsInSection(in: section) ?? 0
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         viewModel?.cellForRowAt(indexPath: indexPath) ?? UITableViewCell()
     }
 }

 class Coordinator {
     func start() {
         let viewModel = SchoolListExampleViewModel { [weak self] action in
             switch action {
             case .exit:
                 // de
                 break
             case .details:
                 self?.coordinateToDetailsViewController()
             }
         }
         let vc = SchoolListExampleViewController(nibName: nil, bundle: nil)
         vc.viewModel = viewModel
         let nav = UINavigationController(rootViewController: vc)
     }
     func coordinateToDetailsViewController() {
         //..
     }
 }
 */
