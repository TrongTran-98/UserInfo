//
//  UserInfoUITests.swift
//  UserInfoUITests
//

import XCTest

final class UserInfoUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Initialize the app
        app = XCUIApplication()
        app.launch()
        
        // Ensure tests stop on failure
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testListUsersViewDisplaysData() throws {
        // Verify the table view exists
        let tableView = app.tables["usersTableView"]
        XCTAssertTrue(tableView.exists, "The table view should exist on the screen.")
        
        // Wait for the first cell to appear
        let firstCell = tableView.cells["userCell_0"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first cell should appear in the table view.")
    }
    
    func testNavigationToDetailViewOnCellTap() throws {
        // Access the table view
        let tableView = app.tables["usersTableView"]
        XCTAssertTrue(tableView.exists, "The table view should exist on the screen.")
        
        // Get the first cell
        let firstCell = tableView.cells["userCell_0"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first cell should appear in the table view.")
        
        // Get user name value in title name
        let userName = firstCell.staticTexts["usernameLabel"].label
        
        // Tap the first cell
        firstCell.tap()
        
        // Verify the detail view is displayed
        let detailLabel = app.staticTexts["usernameLabel"]
        XCTAssertTrue(detailLabel.waitForExistence(timeout: 5), "The detail view should appear after tapping a cell.")
        
        // Get detail user name
        let detailUserName = detailLabel.label
        
        // Check the detail view content (adjust based on your detail view implementation)
        XCTAssertEqual(detailUserName, userName, "The detail view should display the correct user details.")
    }
}
