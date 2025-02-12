import SwiftUI

struct SocialView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    
    @State private var friends: [String] = []
    @State private var friendId: String = ""
    @State private var groupName: String = ""


    var body: some View {
        NavigationView {
            VStack {
                Text("Social").font(.largeTitle)
                
             
                Text("Friends").font(.headline)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(friends, id: \.self) { friend in
                            Text(friend)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                
                Text("Groups").font(.headline)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(socialViewModel.groups, id: \.self) { group in
                            Text(group)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                
                VStack(spacing: 10) {
                    HStack {
                        TextField("Add Friend", text: $friendId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            if let friendIdInt = Int(friendId) {
                                socialViewModel.addFriend(friendId: friendIdInt)
                            } else {
                                print("User with this ID doesn't exist")
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        TextField("Add Group", text: $groupName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            friends = await socialViewModel.fetchFriends()}
        .refreshable {
            friends = await socialViewModel.fetchFriends()
        }
    }
}

#Preview {
    SocialView()
}
