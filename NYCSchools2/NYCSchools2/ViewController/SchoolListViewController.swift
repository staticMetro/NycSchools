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
    var alertController: UIAlertController?
    var isAnimating = false
    var viewModel: SchoolListViewModel?

    /**SEARCH BAR CODE
     var searchController = UISearchController(searchResultsController: nil)
     var filteredSchools: [SchoolModel] = []
     var isSearchBarEmpty: Bool {
       return searchController.searchBar.text?.isEmpty ?? true
     }
     var searchFooterBottomConstraint: NSLayoutConstraint!
     */


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SchoolListViewModel(self)
        self.title = "NYC Schools"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.startAnimation()
        
        /**SEARCH BAR CODE

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search NYC High Schools"
        navigationItem.searchController = searchController
        definesPresentationContext = true
         */
    }

    func startAnimation(){
        if (self.isAnimating == false){
            self.isAnimating = true
            self.alertController = UIAlertController(title: "NYC Schools", message:"Fetching data", preferredStyle: .alert)
            self.present(self.alertController!, animated: true, completion: nil)
        }
    }

    func stopAnimation(){
        self.alertController?.dismiss(animated: true, completion: nil)
        self.alertController = nil
        self.isAnimating = false
    }

    //Function to throw alert.
    func displayAlert(_ error: Error) {
        self.dismiss(animated: false) {
            print("Error while fetching Schools.")
            print(error.localizedDescription)
            let alert = UIAlertController(title: "Error while fetching details.", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
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

    /*
     //Navigate to the school address, by clicking "Navigate" button.
     func navigateToAddress(_ sender: UIButton){

     }
     */
    func fetchCoordinates(_ location: String?) -> CLLocationCoordinate2D?{
        if let schoolAddress = location{
            let coordinateString = schoolAddress.slice(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates{
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
}

extension SchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(inSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier) as! SchoolTableViewCell
        cell.school = viewModel!.data(forRowAt: indexPath)

        //Add button action
        cell.navigateButton.tag = indexPath.row
        return cell
    }
}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = viewModel!.data(forRowAt: indexPath)
        self.performSegue(withIdentifier: "mainToDetailSegue", sender: school)
    }
}

extension SchoolListViewController: SchoolListViewControllerDelegate {
    func fetchSchoolListSuccess(_ failedError: Error?) {
        if let error = failedError {
            self.displayAlert(error)
        }else{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopAnimation()
            }
        }
    }
    func fetchSATSuccess(_ failedError: Error?){
        if let error = failedError {
            self.displayAlert(error)
        }
    }

}
/**SEARCH BAR CODE
extension SchoolListViewController: UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String){
        //filteredSchools = (viewModel?.schools.filter(<#T##isIncluded: (SchoolModel) throws -> Bool##(SchoolModel) throws -> Bool#>))!
        //return school.school_name?.contains(searchText)
        tableView.reloadData()
    }
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
 */


extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
