//
//  UserListViewModel.swift
//  UserInfo
//

import Foundation

class UserListViewModel: BaseViewModel {
    
    private let fetchUsersUsecase: FetchUsersUsecase
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    
    private(set) var hasMore: Bool = true
    private let pageSize: Int = 20
    
    
    init(fetchUsersUsecase: FetchUsersUsecase = DefaultFetchUsersUsecase()) {
        self.fetchUsersUsecase = fetchUsersUsecase
    }
    
    func fetchUsers() {
        guard !isLoading, hasMore else { return }
        /// Update loading status
        self.isLoading = true
        /// Fetch users
        let lastId = users.last?.id ?? 0
        self.fetchUsersUsecase.fetchUsers(pageSize: pageSize,
                                          sinceId: lastId) { [weak self] result in
            guard let self = self else { return }
            /// Update loading status
            self.isLoading = false
            /// Handle result
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.hasMore = users.count == 20
                    self.users.append(contentsOf: users)
                    print("fetched success \(users.count)")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func refresh() {
        /// Reset
        users.removeAll()
        hasMore = true
        /// Fetch users
        fetchUsers()
    }
    
}
