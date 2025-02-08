import XCTest
@testable import CarbonSplitGo

//due to tests being used against a database, and due to them being ran asyncronously, need to do one by one, otherwise some will fail
//due to missing values. Not worth the effor to fix

class AuthenticationViewModelTests: XCTestCase {
    
    var authenticationViewModel: AuthenticationViewModel!
        
    //basically needed so it sets up before each test, and then clears after each test, otherwise it'll explode and not work
    override func setUp() {
        super.setUp()
        authenticationViewModel = AuthenticationViewModel()
    }
    
    override func tearDown() {
        authenticationViewModel = nil
        super.tearDown()
    }
    
    func testRegisterUser_Success() {
        let user = User(
            userName: "testUser",
            userEmail: "testUser@gmail.com",
            userPassword: "testUserPassword",
            userFirstName: "testUserName",
            userLastName: "testUserSurname",
            isActive: true,
            isVerified: false,
            verificationToken: nil,
            userPhoneNumber: "1234567890",
            userProfilePictureURL: nil,
            userDateOfBirth: "2000-01-01",
            userDefaultRole: "driver"
        )
        
        let expectation = self.expectation(description: "User can register")
        
        authenticationViewModel.registerUser(user: user) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(self.authenticationViewModel.user?.userEmail, user.userEmail)
            XCTAssertNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRegisterUser_Failure() {
        let user = User(
            userName: "",
            userEmail: "",
            userPassword: "",
            userFirstName: "",
            userLastName: "",
            isActive: false,
            isVerified: false,
            verificationToken: nil,
            userPhoneNumber: "",
            userProfilePictureURL: nil,
            userDateOfBirth: "",
            userDefaultRole: ""
        )
        
        let expectation = self.expectation(description: "User failed to register")
        
        authenticationViewModel.registerUser(user: user) { success in
            XCTAssertFalse(success)
            XCTAssertNotNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginUser_Success() {
        
        
        let email = "testUser@gmail.com"
        let password = "testUserPassword"
        
        let expectation = self.expectation(description: "User can login")
        
        authenticationViewModel.loginUser(email: email, password: password) { success in
            XCTAssertTrue(success)
            XCTAssertNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginUser_Failure() {
        let email = "testUser@gmail.com"
        let password = "testUserPassword"
        
        let expectation = self.expectation(description: "User failed to login")
        
        authenticationViewModel.loginUser(email: email, password: password) { success in
            XCTAssertFalse(success)
            XCTAssertNotNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testDeleteUser_Failure() {
        let email = "testUserWrong@gmail.com"
        
        let expectation = self.expectation(description: "User failed to be deleted")
        
        authenticationViewModel.deleteUser(email: email) { success in
            XCTAssertFalse(success)
            XCTAssertNotNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testDeleteUser_Success() {
                
        let email = "testUser@gmail.com"
        
        let expectation = self.expectation(description: "User can be deleted")
        
        authenticationViewModel.deleteUser(email: email) { success in
            XCTAssertTrue(success)
            XCTAssertNil(self.authenticationViewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    //most of these tests for documentation later
    func testHashPassword() {
        let password = "testUserPassword"
        let hashedPassword = AuthenticationViewModel.hashPassword(password)
        
        XCTAssertEqual(hashedPassword.count, 64)
        XCTAssertNotEqual(hashedPassword, password)
    }
}
