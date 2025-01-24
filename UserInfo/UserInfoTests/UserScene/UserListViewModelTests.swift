//
//  UserListViewModelTests.swift
//  UserInfo
//

@testable import UserInfo
import XCTest
import Combine

class UserListViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchUsersSuccess() {
        let repository = MockRepository()
        let viewModel = UserListViewModel(fetchUsersUsecase: DefaultFetchUsersUsecase(userRepository: repository))
        
        repository.expectResult = .fetchUsersSuccess
        
        viewModel.$users.receive(on: DispatchQueue.main).sink(receiveValue: { users in
            // Assert
            XCTAssertEqual(viewModel.users.count, 20)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUsers()
    }
    
    func testFetchUsersFailWithNoNetworkError() {
        let repository = MockRepository()
        let viewModel = UserListViewModel(fetchUsersUsecase: DefaultFetchUsersUsecase(userRepository: repository))
        
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
        
        viewModel.fetchUsers()
    }
    
    func testFetchUsersFailWithNoDataError() {
        let repository = MockRepository()
        let viewModel = UserListViewModel(fetchUsersUsecase: DefaultFetchUsersUsecase(userRepository: repository))
        
        repository.expectResult = .noDataError
        
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { error in
            // Assert
            guard let urlError = error as? URLSessionError else {
                XCTFail("Error should be URLSessionError")
                return
            }
            XCTAssertEqual(urlError.description, URLSessionError.noData.description)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUsers()
    }
    
    func testFetchUsersFailWithUnknowError() {
        let repository = MockRepository()
        let viewModel = UserListViewModel(fetchUsersUsecase: DefaultFetchUsersUsecase(userRepository: repository))
        
        repository.expectResult = .unknowError
        
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink(receiveValue: { error in
            // Assert
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 09)
            XCTAssertFalse(viewModel.isLoading)
        }).store(in: &cancellables)
        
        viewModel.fetchUsers()
    }

}
