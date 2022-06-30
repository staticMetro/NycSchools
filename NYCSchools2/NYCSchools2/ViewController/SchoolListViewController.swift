//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import UIKit
import MapKit

class SchoolListViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource,
                                UITableViewDelegate, SchoolListViewModelDelegateProtocol {
    @IBOutlet weak internal var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak internal var activityIndicator: UIActivityIndicatorView!
    internal var schoolListViewModel: SchoolListViewModel?
    internal var searchController = UISearchController(searchResultsController: nil)
    internal var searchFooterBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        schoolListViewModel = SchoolListViewModel()
        title = "NYC Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBarSetup()
        activityIndicator.startAnimating()
    }
    func searchBarSetup() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search NYC High Schools"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    // Function to throw alert.
    func displayAlert(_ error: Error) {
            print("Error while fetching Schools.")
            print(error.localizedDescription)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let school = sender as? SchoolModel,
        let detailsView = segue.destination as? SchoolListDetailViewController else {
            return
        }
        detailsView.view.tag = 0
        detailsView.loadDetailView(school)
    }
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
