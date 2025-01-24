//
//  UserListViewController.swift
//  UserInfo
//

import UIKit
import SnapKit
import Foundation
import Combine

class UserListViewController: BaseViewController {
    
    var userListViewModel: UserListViewModel? { return viewModel as? UserListViewModel }
    
    init(viewModel: UserListViewModel = UserListViewModel()) {
        let viewModel = UserListViewModel()
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = "usersTableView"
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UserViewCell.self, forCellReuseIdentifier: "UserViewCell")
        return tableView
    }()
    
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.userListViewModel?.fetchUsers()
        })
    }
    
    // MARK: - Binding
    override func binding() {
        super.binding()
        // Binding here
        guard let listViewModel = userListViewModel else { return }
        
        listViewModel.$isLoading.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] isLoading in
            guard let self = self else { return }
            if !isLoading {
                self.refresh.endRefreshing()
                self.hideLoadingIndicatorView()
            } else {
                // Show at initial loading
                if dataSource.isEmpty {
                    self.showLoadingIndicatorView()
                }
            }
        }).store(in: &cancellables)
        
        listViewModel.$users.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).store(in: &cancellables)
    }
    
    // MARK: - Setup View
    private func setupView() {
        navigationItem.title = "Github Users"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        userListViewModel?.refresh()
    }
    
    // MARK: - Handle Error
    override func handleError(error: any Error) {
        /// Stop refresh indicator
        refresh.endRefreshing()
        /// Only show error on intial state
        if dataSource.isEmpty {
            super.handleError(error: error)
        }
    }
    
    // MARK: - Action
    private func showDetailUser(user: User) {
        guard let loginName = user.login else { return }
        let controller = UserDetailsViewController(loginName: loginName)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Table View

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    var dataSource: [User] { userListViewModel?.users ?? [] }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as? UserViewCell else { return UITableViewCell() }
        let user = dataSource[indexPath.row]
        cell.bind(user)
        cell.accessibilityIdentifier = "userCell_\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Try to load more when reached last cell
        if indexPath.row == dataSource.count - 1 && !dataSource.isEmpty {
            userListViewModel?.fetchUsers()
        }
        // Show bottom indicator if need
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && userListViewModel?.hasMore ?? false {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        showDetailUser(user: user)
    }
}
