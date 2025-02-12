import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var groups: [String] = []
    
    
    private var userId: Int? {
            Session.shared.getUserID()
        }
    //i need to do this more often, this is great

    
    func fetchFriends() async -> [String] {
        guard let userId = userId else { return [] } // Return an empty list if userId is nil

        do {
            let fetchedFriends = try await SocialQueries.retrieveUserFriends(userId: userId)
            return fetchedFriends
        } catch {
            print("Error fetching friends: \(error)")
            return [] 
        }
    }

    func addFriend(friendId: Int) {
        guard let userId = Session.shared.getUserID() else { return }
        
        do {
            try SocialQueries.insertFriendship(userId: userId, friendId: friendId)
        } catch {
            print("Error adding a friend: \(error)")
        }
    }
    
}
