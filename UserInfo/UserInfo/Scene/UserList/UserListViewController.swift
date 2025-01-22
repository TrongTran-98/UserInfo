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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
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
    
    override func binding() {
        super.binding()
        // Binding here
        guard let listViewModel = userListViewModel else { return }
        
        listViewModel.$isLoading.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] isLoading in
            guard let self = self else { return }
            if !isLoading {
                self.refresh.endRefreshing()
            }
            // TODO: - Show loading
        }).store(in: &cancellables)
        
        listViewModel.$users.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).store(in: &cancellables)
    }
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        showDetailUser(user: user)
    }
}
