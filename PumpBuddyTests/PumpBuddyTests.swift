//
//  PumpBuddyTests.swift
//  PumpBuddyTests
//
//  Created by udit on 07/08/23.
//
import SwiftUI
import XCTest
@testable import PumpBuddy

final class PumpBuddyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class AccountTabViewTests: XCTestCase {
    
    //Test to check whether the accounttabview is loading and making sure user the user information will be properly displayed on screen
    func testAccountTabViewInitialization() {
        // Arrange
        let accountTabView = AccountTabView()
        
        XCTAssertNotNil(accountTabView.body, "AccountTabView body should not be nil")
    }
    
    //Test to check whether the email field is not empty as having an email is required to sign up
    func testEmailDisplay() {
        // Arrange
        let accountTabView = AccountTabView()
        
        XCTAssertNotNil(accountTabView.email, "Email should not be nil")
    }
    
    //Tests to make sure that a password has been entered and that the password and the confirm password and matching
    func testPassword() {
        // Arrange
        let accountTabView = AccountTabView()
        
        XCTAssertNotNil(accountTabView.password, "Password should not be nil")
        XCTAssertEqual(accountTabView.password, accountTabView.confirmedPassword)
    }
    
    func testNameDisplay() {
        // Arrange
        let accountTabView = AccountTabView()
        
        XCTAssertNotNil(accountTabView.username, "Username should not be nil")
    }
    
    
    
}



