//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import UIKit
import MapKit

class SchoolListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var alertController: UIAlertController?
    // @IBOutlet weak var searchBar: UISearchBar!
    var isAnimating = false
    var schoolListViewModel: SchoolListViewModel?
    var searchController = UISearchController(searchResultsController: nil)
    var filteredSchools: [SchoolModel] = []
    var searchFooterBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        schoolListViewModel = SchoolListViewModel(self)
        self.title = "NYC Schools"
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
    func startAnimation() {
        if self.isAnimating == false {
            self.isAnimating = true
            self.alertController = UIAlertController(title: "NYC Schools",
                                                     message: "Fetching data", preferredStyle: .alert)
            self.present(self.alertController!, animated: true, completion: nil)
        }
    }

    func stopAnimation() {
        self.alertController?.dismiss(animated: true, completion: nil)
        self.alertController = nil
        self.isAnimating = false
    }

    // Function to throw alert.
    func displayAlert(_ error: Error) {
        self.dismiss(animated: false) {
            print("Error while fetching Schools.")
            print(error.localizedDescription)
            let alert = UIAlertController(title: "Error while fetching details.",
                                          message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                          style: .`default`, handler: { _ in
                print("Error while fetching details.")
            }))
            self.present(alert, animated: true, completion: nil)

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let school = sender as? SchoolModel {
            let detailsView = segue.destination as? SchoolListDetailViewController
            detailsView?.view.tag = 0
            detailsView?.loadDetailView(school)
        }
    }

    // Navigate to the school address, by clicking "Navigate" button.
    /*
     func navigateToAddress(_ sender: UIButton){




     }
     */
    func fetchCoordinates(_ schoolLocation: String?) -> CLLocationCoordinate2D? {
        /*

         if let schoolAddress = schoolLocation{
             let coordinateString = schoolAddress.slice(start: "(", end: ")")
             let coordinates = coordinateString?.components(separatedBy: ",")
             if let coordinateArray = coordinates{
                 let latitude = (coordinateArray[0] as NSString).doubleValue
                 let longitude = (coordinateArray[1] as NSString).doubleValue
<<<<<<< HEAD
                 return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                        longitude: CLLocationDegrees(longitude))
=======
                 return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
>>>>>>> ddb4563204a0f52a875cf528223dad87ea037307
             }
         }

         guard schoolLocation != nil else {
             let schoolAddress = schoolLocation
             let coordinateArray = schoolAddress!.slice(start: "(", end: ")")?.components(separatedBy: ",")
             let schoolLatitude = (coordinateArray![0] as NSString).doubleValue
             let schoolLongitude = (coordinateArray![1] as NSString).doubleValue
             return CLLocationCoordinate2D(latitude: CLLocationDegrees(schoolLatitude),
                                           longitude: CLLocationDegrees(schoolLongitude))
         }
         */
        guard schoolLocation != nil else {
            let schoolAddress = schoolLocation
            let coordinateArray = schoolAddress!.slice(start: "(", end: ")")?.components(separatedBy: ",")
            let schoolLatitude = (coordinateArray![0] as NSString).doubleValue
            let schoolLongitude = (coordinateArray![1] as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(schoolLatitude),
                                          longitude: CLLocationDegrees(schoolLongitude))
        }
        return nil
    }
}

extension SchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
          return filteredSchools.count
        }
        return schoolListViewModel?.numberOfRows(inSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier) as! SchoolTableViewCell
        // swiftlint:enable force_cast
        if isFiltering() {
            cell.school = filteredSchools[indexPath.row]
        } else {
            cell.school = schoolListViewModel!.data(forRowAt: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = schoolListViewModel!.data(forRowAt: indexPath)
        self.performSegue(withIdentifier: "mainToDetailSegue", sender: school)
    }
}

extension SchoolListViewController: SchoolListViewControllerDelegate {
    func fetchSchoolListSuccess(_ failedError: Error?) {
        if let error = failedError {self.displayAlert(error)} else {
            DispatchQueue.main.async { [self] in
                self.tableView.reloadData()
                activityIndicator.stopAnimating()
            }
        }
    }
    func fetchSATSuccess(_ failedError: Error?) {
        if let error = failedError {self.displayAlert(error)}
    }
}
extension SchoolListViewController: UISearchResultsUpdating {
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
        filteredSchools = (schoolListViewModel?.schools.filter({( school: SchoolModel) -> Bool in
            return school.schoolName!.lowercased().contains(searchText.lowercased())
        }))!
        tableView.reloadData()
    }
}
