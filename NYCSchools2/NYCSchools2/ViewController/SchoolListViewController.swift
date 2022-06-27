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
        schoolListViewModel = SchoolListViewModel(self)
        title = "NYC Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
        activityIndicator.startAnimating()
        searchBarSetup()
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
        /*
        if let school = sender as? SchoolModel {
            let detailsView = segue.destination as? SchoolListDetailViewController
            detailsView?.view.tag = 0
            detailsView?.loadDetailView(school)
        }

         guard let school = sender as? SchoolModel,
         let detailsView = segue.destination as? SchoolListDetailViewController else {
             return
         }
         detailsView.view.tag = 0
         detailsView.loadDetailView(school)
         */
        guard let school = sender as? SchoolModel,
        let detailsView = segue.destination as? SchoolListDetailViewController else {
            return
        }
        detailsView.view.tag = 0
        detailsView.loadDetailView(school)
    }
}
