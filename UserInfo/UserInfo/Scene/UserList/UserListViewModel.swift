//
//  UserListViewModel.swift
//  UserInfo
//

import Foundation

class UserListViewModel: BaseViewModel {
    
    private let fetchUsersUsecase: FetchUsersUsecase
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    
    private let pageSize: Int = 20
    private var hasMore: Bool = true
    
    init(fetchUsersUsecase: FetchUsersUsecase = DefaultFetchUsersUsecase()) {
        self.fetchUsersUsecase = fetchUsersUsecase
    }
    
    func fetchUsers() {
        guard !isLoading, hasMore else { return }
        /// Update loading status
        self.isLoading = true
        /// Fetch users
        self.fetchUsersUsecase.fetchUsers(pageSize: pageSize,
                                     sinceId: users.last?.id ?? 0) { [weak self] result in
            guard let self = self else { return }
            /// Update loading status
            self.isLoading = false
            /// Handle result
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.hasMore = users.count == 20
                    self.users.append(contentsOf: users)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
}
