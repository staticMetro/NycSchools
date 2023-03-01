//
//  SchoolListViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit
import MapKit

class SchoolListViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
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
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? false)
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
        viewModel?.updateSchoolList()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
    }

    //TODO: Create a container view to assign to tableheader View, assign searchBar to containerView, refer to chatGPT convo

    func setupUI() {
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search school name..."
        searchController.searchBar.scopeButtonTitles = ["All", "Brooklyn", "Manhattan",
                                                        "Queens", "Bronx", "Staten Is"]
        searchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        searchController.searchBar.isTranslucent = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }

    func configureUI() {
        let searchBar = searchController.searchBar
        guard let tableViewHeader = tableView.tableHeaderView else {
            return
        }
        view.addSubview(tableView)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        configureConstraints()
//        tableViewHeader.contentMode = .center
    }
    
    func configureConstraints() {
        let searchBar = searchController.searchBar
        guard let tableViewHeader = tableView.tableHeaderView else {
            return
        }
        
        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: 50),

            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        viewModel?.filterContentForSearchText(searchBar.text ?? "",
                                              scope: (searchBar.scopeButtonTitles?[selectedScope]) ?? "All")
        tableView.reloadData()
    }
}
