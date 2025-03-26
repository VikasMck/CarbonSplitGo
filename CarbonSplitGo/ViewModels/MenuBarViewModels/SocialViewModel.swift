import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    
    private var userId: Int? {
            Session.shared.getUserID()
        }
    
    
    //yes I can fetch them both at the same time, but I will need them separate
    func fetchFriends() async -> [(userId: Int, userName: String)] {
        guard let userId = userId else { return [] }

        do {
            let fetchedFriends = try SocialQueries.retrieveUserFriends(userId: userId)
            return fetchedFriends.map { ($0.userId, $0.userName) }
        }
        catch {
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
    
    
    func updateMessageReadStatus(senderId: Int, receiverId: Int) async {
        do{
            try await MessagesQueries.updateMessageReadStatusInDb(
                senderId: senderId,
                receiverId: receiverId)
        } catch {
            self.errorMessage = "Error when updating read status of a message: \(error.localizedDescription)"
        }
    }

    func fetchUnreadMessages(userId: Int) async -> [(whichUser: Int, messageCount: Int)]? {
        do {
            let unreadMessages = try MessagesQueries.retrieveUnreadMessages(userId: userId)
            
            guard !unreadMessages.isEmpty else {
                print("Error, no unread messages found for user \(userId).")
                return []
            }
            
            return unreadMessages.map { (whichUser: $0.whichUser, messageCount: $0.messageCount) }
            
        } catch {
            self.errorMessage = "Error retrieving unread messages: \(error.localizedDescription)"
            return nil
        }
    }
    
    func clearUnreadMessages(userId: Int) async {
        do {
            try await MessagesQueries.clearUnreadMessagesFromDB(userId: userId)
        } catch {
            self.errorMessage = "Error clearing unread messages: \(error.localizedDescription)"
        }
    }
    
}
