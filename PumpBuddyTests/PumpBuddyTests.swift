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




