import SwiftUI

struct SocialView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    
    @State private var friends: [String] = []
    @State private var groups: [String] = []
    @State private var friendId: String = ""
    @State private var groupName: String = ""


    var body: some View {
        NavigationView {
            VStack {
                Text("Social Page!")
                    .font(.custom("Sen", size: 45))
                    .fontWeight(.bold)
                    .foregroundColor(AppColours.customDarkGrey)
                    .padding(.bottom, 20)
                
                HStack {
                    CustomTextField(placeholder: "Add a Friend!", text: $friendId)
                    Button(action: {
                        if let friendIdInt = Int(friendId) {
                            socialViewModel.addFriend(friendId: friendIdInt)
                        } else {
                            print("User with this ID doesn't exist")
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding()
//                Text("Friends").font(.headline)
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
                Divider().frame(width: 300,height: 3).background(AppColours.customDarkGreen)
                HStack {
                    CustomTextField(placeholder: "Join a Group!", text: $groupName)
                    Button(action: {
                        socialViewModel.joinGroup(groupName: groupName)
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding()
//                Text("Groups").font(.headline)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(groups, id: \.self) { group in
                            Text(group)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            .background(AppColours.customLightGreen)
        }
        .task {
            friends = await socialViewModel.fetchFriends()
            groups = await socialViewModel.fetchGroups()
        }
        .refreshable {
            friends = await socialViewModel.fetchFriends()
            groups = await socialViewModel.fetchGroups()
        }
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 35, y: -10)
            }
        )
    }
}

#Preview {
    SocialView()
}
