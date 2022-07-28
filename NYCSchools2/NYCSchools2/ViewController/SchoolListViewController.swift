//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

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
        title = "NYC Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search NYC High Schools"
        searchController.searchBar.scopeButtonTitles = ["All", "Brooklyn", "Manhattan", "Queens", "Bronx", "Staten Island"]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func configureUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
}

extension SchoolListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSection() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section, isFiltering: isFiltering) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel?.data(forRowAt: indexPath, isFiltering: isFiltering) else { return UITableViewCell() }
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
        viewModel?.filterContentForSearchText(searchController.searchBar.text)
        tableView.reloadData()
    }
}
