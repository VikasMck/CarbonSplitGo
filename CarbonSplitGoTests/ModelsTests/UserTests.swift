import XCTest

class UserTest: XCTestCase {
    func testUserInitialization() {
        let user = User(
            userName: "testuser",
            userEmail: "test@example.com",
            userPassword: "password123",
            userFirstName: "Test",
            userLastName: "User",
            userPhoneNumber: "1234567890",
            userProfilePictureURL: nil,
            userDateOfBirth: Date(),
            userDefaultRole: "user",
            isActive: true,
            isVerified: false,
            verificationToken: "token"
        )
        XCTAssertEqual(user.userName, "testuser")
    }
}
