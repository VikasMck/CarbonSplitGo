import Foundation

//custom session manager as swift doesnt have one. Straighforward
class Session {
    static let shared = Session()
    private init() {}

    private var userID: Int?

    func setUserID(_ id: Int) {
        self.userID = id
    }

    func getUserID() -> Int? {
        return userID
    }

    func clearSession() {
        userID = nil
    }
}
