protocol Authenticatable {
    func insertUser(user: User) throws
    func authenticateUser(email: String, password: String) throws -> Bool
}
