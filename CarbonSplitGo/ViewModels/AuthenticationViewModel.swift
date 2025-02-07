import SwiftUI
import Foundation
import CryptoKit

class AuthenticationViewModel: ObservableObject {
    @Published var user: User?
    //will use for unittests
    @Published var errorMessage: String?

    func registerUser(user: User, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                //use the statement with user's fields
                try AuthenticationQueries.insertUser(user: user)
                DispatchQueue.main.async {
                    self.user = user
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Registration error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let success = try AuthenticationQueries.authenticateUser(email: email, password: password)
                DispatchQueue.main.async {
                    completion(success)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Login error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
    
    //standard hashing
    static func hashPassword(_ password: String) -> String {
        //convert to Data utf8 from Foundation
        let passwordData = Data(password.utf8)
        let hashedPassword = SHA256.hash(data: passwordData)
        //map it back into a two char hexdec string
        return hashedPassword.map { String(format: "%02x", $0) }.joined()
    }
}
