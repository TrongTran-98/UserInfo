//
//  testRealmStorage.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/23/25.
//

@testable import UserInfo
import XCTest
import RealmSwift

class NWMock: NWMonitor {
    var isConnected: Bool = true
    var isUsingCellular: Bool = true
}

class RealmStorageTests: XCTestCase {
    var storage: RealmStorage!
    var nwMonitor: NWMonitor!
    
    override func setUp() {
        super.setUp()
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        let mockNWMonitor = NWMock()
        nwMonitor = mockNWMonitor
        storage = RealmStorage(realm: realm, nwMonitor: mockNWMonitor)
    }
    
    override func tearDown() {
        storage = nil
        super.tearDown()
    }
    
    func testSaveUsers() {
        let users = [User(id: 0, login: "Alice", avatarUrl: nil, htmlUrl: nil,
                          location: nil, followers: nil, following: nil),
                     User(id: 1, login: "Bod", avatarUrl: nil, htmlUrl: nil,
                          location: nil, followers: nil, following: nil)]
        
        let expectation = XCTestExpectation(description: "Save users")
        storage.saveUsers(users)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.storage.fetchAllUsers(completion: { result in
                switch result {
                case .success(let cachedUsers):
                    XCTAssertEqual(cachedUsers.count, users.count)
                    XCTAssertEqual(cachedUsers[0].id, users[0].id)
                    XCTAssertEqual(cachedUsers[1].login, users[1].login)
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Fetch users should not fail")
                }
            })
            
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testRemoveAllUsers() {
        let users = [User(id: 0, login: "Alice", avatarUrl: nil, htmlUrl: nil,
                          location: nil, followers: nil, following: nil),
                     User(id: 1, login: "Bod", avatarUrl: nil, htmlUrl: nil,
                          location: nil, followers: nil, following: nil)]
        
        storage.saveUsers(users)
        
        let expectation = XCTestExpectation(description: "Remove all users")
        storage.removeAllUsers { result in
            switch result {
            case .success:
                self.storage.fetchAllUsers(completion: { result in
                    switch result {
                    case .success(let cachedUsers):
                        XCTAssertEqual(cachedUsers.count, 0)
                        expectation.fulfill()
                    case .failure(_):
                        XCTFail("Fetch users should not fail")
                    }
                })
            case .failure:
                XCTFail("Remove users should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testThrowNetworkErrorWhenDataIsEmpty() {
        nwMonitor.isConnected = false
        
        let expectation = XCTestExpectation(description: "No network connection error occurs")
        storage.removeAllUsers { result in
            switch result {
            case .success:
                self.storage.fetchAllUsers(completion: { result in
                    switch result {
                    case .success(_):
                        XCTFail("Fetch users should not success")
                    case .failure(let error):
                        guard let urlError = error as? URLSessionError else {
                            XCTFail("Error should be URLSessionError.noInternet")
                            return
                        }
                        XCTAssertEqual(urlError.description, URLSessionError.noInternet.description)
                        expectation.fulfill()
                    }
                })
            case .failure:
                XCTFail("Remove users should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
