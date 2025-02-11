import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    @Published var friends: [String] = []
    @Published var groups: [String] = []
    @Published var addFriend: String = ""
    @Published var joinGroup: String = ""
    
    private var userId: Int? {
            Session.shared.getUserID()
        }
    //i need to do this more often, this is great
    init() {
        fetchFriends()
    }
    
    func fetchFriends() {
        guard let userId = userId else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let fetchedFriends = try SocialQueries.retrieveUserFriends(userId: userId)
                
                DispatchQueue.main.async {
                    self?.friends = fetchedFriends
                }
            } catch {
                print("Error fetching friends: \(error)")
            }
        }
    }
    
}
