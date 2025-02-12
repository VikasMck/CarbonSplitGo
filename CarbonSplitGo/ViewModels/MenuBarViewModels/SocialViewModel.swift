import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var groups: [String] = []
    
    
    private var userId: Int? {
            Session.shared.getUserID()
        }
    
    
    //yes I can fetch them both at the same time, but I will need them separate
    func fetchFriends() async -> [String] {
        guard let userId = userId else { return [] }

        do {
            let fetchedFriends = try SocialQueries.retrieveUserFriends(userId: userId)
            return fetchedFriends
        } catch {
            print("Error fetching friends: \(error)")
            return [] 
        }
    }
    
    func fetchGroups() async -> [String] {
        guard let userId = userId else { return [] }

        do {
            let fetchedGroups = try SocialQueries.retrieveUserGroups(userId: userId)
            return fetchedGroups
        } catch {
            print("Error fetching groups: \(error)")
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
    
    func joinGroup(groupName: String) {
        guard let userId = Session.shared.getUserID() else { return }
        
        do {
            try SocialQueries.insertGroup(groupName: groupName, userId: userId)
        } catch {
            print("Error joining a group: \(error)")
        }
    }
    
}
