//
//  UserDetailViewModelTests.swift
//  UserInfo
//

@testable import UserInfo
import XCTest
import Combine

class UserDetailViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchUsersSuccess() {
        let repository = MockRepository()
        let viewModel = UserDetailsViewModel(loginName: "jvantuyl", fetchUsecase: DefaultFetchUserDetailsUsecase(userRepository: repository))
        
        repository.expectResult = .fetchUsersSuccess
        
        viewModel.$user.receive(on: DispatchQueue.main).sink(receiveValue: { user in
            XCTAssertEqual(viewModel.user?.login, "jvantuyl")
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUserDetails()
    }
    
    func testFetchUserDetailFailWithNoNetworkError() {
        let repository = MockRepository()
        let viewModel = UserDetailsViewModel(loginName: "jvantuyl", fetchUsecase: DefaultFetchUserDetailsUsecase(userRepository: repository))
        
        repository.expectResult = .noInternetError
        
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { error in
            // Assert
            guard let urlError = error as? URLSessionError else {
                XCTFail("Error should be URLSessionError")
                return
            }
            XCTAssertEqual(urlError.description, URLSessionError.noInternet.description)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUserDetails()
    }
    
    func testFetchUserDetailFailWithNoDataError() {
        let repository = MockRepository()
        let viewModel = UserDetailsViewModel(loginName: "jvantuyl", fetchUsecase: DefaultFetchUserDetailsUsecase(userRepository: repository))
        
        repository.expectResult = .noDataError
        
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { error in
            // Assert
            guard let urlError = error as? URLSessionError else {
                XCTFail("Error should be URLSessionError type")
                return
            }
            XCTAssertEqual(urlError.description, URLSessionError.noData.description)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUserDetails()
    }
    
    func testFetchUserDetailFailWithUnknowError() {
        let repository = MockRepository()
        let viewModel = UserDetailsViewModel(loginName: "jvantuyl", fetchUsecase: DefaultFetchUserDetailsUsecase(userRepository: repository))
        
        repository.expectResult = .unknowError
        
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 09)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUserDetails()
    }

}
