import PostgresClientKit

struct AuthenticationQueries {
    static func insertUser(user: User) throws {
        let hashedPassword = AuthenticationViewModel.hashPassword(user.userPassword)
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLQueries.insertUser)
        defer {
            statement.close()
        }
        
        try statement.execute(parameterValues: [
            user.userName,
            user.userEmail,
            hashedPassword,
            user.userFirstName,
            user.userLastName,
            user.userPhoneNumber,
            user.userProfilePictureURL,
            user.userDateOfBirth,
            user.userDefaultRole,
            user.isActive,
            user.isVerified,
            user.verificationToken
        ])
    }
    
    static func authenticateUser(email: String, password: String) throws -> Bool {
        let hashedPassword = AuthenticationViewModel.hashPassword(password)
        
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLQueries.authenticateUser)
        defer {
            statement.close()
        }
        
        //this checks whether a value if found, if yes it allows to login and stores a session var
        let cursor = try statement.execute(parameterValues: [email, hashedPassword])
        //why was this so harddddd
        if let result = cursor.next(),
           let row = try? result.get(),
           let userId = try? row.columns[0].int() {
            Session.shared.setUserID(userId)
            print("the user is logged in with id: \(userId)")

            return true
        }
        
        return false
    }
    
    static func deleteUser(email: String) throws -> Bool {
     
        let connection = try PostgresConnect.getConnection()
        defer {
            connection.close()
        }
        
        let statement = try connection.prepareStatement(text: SQLQueries.deleteUser)
        defer {
            statement.close()
        }
        
        let result = try statement.execute(parameterValues: [email])
        
        //just check if any rows updated
        if result.rowCount! > 0{
            return true
        }
        return false
    }
    

}
