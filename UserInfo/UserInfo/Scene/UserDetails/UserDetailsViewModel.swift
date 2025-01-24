//
//  UserDetailsViewModel.swift
//  UserInfo
//

import Foundation
import Combine

class UserDetailsViewModel: BaseViewModel {
    
    private let fetchUsecase: FetchUserDetailsUsecase
    private let loginName: String
    
    @Published private(set) var user: User?
    @Published private(set) var isLoading: Bool = false
    
    init(loginName: String, fetchUsecase: FetchUserDetailsUsecase = DefaultFetchUserDetailsUsecase()) {
        self.fetchUsecase = fetchUsecase
        self.loginName = loginName
    }
    
    // MARK: - Fetch Data
    func fetchUserDetails() {
        guard !isLoading else { return }
        /// Update loading status
        self.isLoading = true
        /// Fetch users
        self.fetchUsecase.fetchUserDetail(loginName: loginName) { [weak self] result in
            guard let self = self else { return }
            /// Update loading status
            self.isLoading = false
            /// Handle result
            switch result {
            case .success(let user):
                self.user = user
                print("Fetched user detail success \(user.login ?? "")")
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
}
