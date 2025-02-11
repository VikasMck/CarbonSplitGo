import Foundation

//custom session manager as swift doesnt have one. Straighforward
class Session {
    static let shared = Session()
    private init() {}

    private var userID: Int?
    private var userEmail: String?

    func setUserID(_ id: Int) {
        self.userID = id
    }

    func getUserID() -> Int? {
        return userID
    }
    
    func setUserEmail(_ email: String) {
        self.userEmail = email
    }
    
    func getUserEmail() -> String? {
        return userEmail
    }

    func clearSession() {
        userID = nil
        userEmail = nil
    }
}
