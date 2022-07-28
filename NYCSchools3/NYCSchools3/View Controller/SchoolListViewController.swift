//
//  SchoolListViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit
import MapKit

class SchoolListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        view.separatorStyle = .singleLine
        view.separatorColor = .gray
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private var searchController = UISearchController(searchResultsController: nil)
    private var searchFooterBottomConstraint: NSLayoutConstraint!
    private let schoolsCellProvider: SchoolsCellProviding

    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    init(schoolsCellProvider: SchoolsCellProviding) {
        self.schoolsCellProvider = schoolsCellProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: SchoolListViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }


    func setupUI() {
        view.addSubview(searchController.searchBar)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search school name..."
        searchController.searchBar.scopeButtonTitles = ["All", "Brooklyn", "Manhattan",
                                                        "Queens", "Bronx", "Staten Is"]
        tableView.tableHeaderView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.isTranslucent = false
    }

    func configureUI() {
        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            searchController.searchBar.topAnchor.constraint(equalTo: view.topAnchor),
//            searchController.searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 50)
//        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.topAnchor.constraint(lessThanOrEqualTo: searchController.searchBar.bottomAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    func isFiltering(_ searchController: UISearchController) -> Bool {
        let searchScope = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty(searchController) || searchScope)
    }
    func searchBarIsEmpty(_ searchController: UISearchController)
    -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
}

extension SchoolListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSection() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section, isFiltering: isFiltering) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel?.data(forRowAt: indexPath, isFiltering: isFiltering)
        else { return UITableViewCell() }
        return schoolsCellProvider.cellFor(data: data, tableView: tableView, cellForRowAt: indexPath)
    }
    // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 32}
}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let school = viewModel?.data(forRowAt: indexPath, isFiltering: isFiltering) else { return }
        viewModel?.handleAction(action: .details(school))
    }
}

extension SchoolListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else {return}
        viewModel?.filterContentForSearchText(searchController.searchBar.text ?? "", scope: scope)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel?.filterContentForSearchText(searchBar.text ?? "", scope: (searchBar.scopeButtonTitles?[selectedScope])
                                              ?? "All")
    }
}
