import SwiftUI

struct SocialView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    
    @State private var friends: [(userId: Int, userName: String)] = []
    @State private var unreadMessages: [(whichUser: Int, messageCount: Int)]? = []
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
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(friends.indices, id: \.self) { index in
                            let friend = friends[index]
                            if let unread = unreadMessages?.first(where: { $0.whichUser == friend.userId }) {
                                HStack {
                                    Text(friend.userName)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColours.customLightGreen)
                                        .cornerRadius(30)
                                    Text("\(unread.messageCount) Unread")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                    NavigationLink(destination: MessagesView(senderId: Session.shared.getUserID() ?? 0, receiverId: friend.userId, friendName: friend.userName)
                                        .navigationBarBackButtonHidden(true)) {
                                        Image(systemName: "message")
                                                .foregroundColor(AppColours.customBlack)
                                            .font(.custom("Sen", size: 20))
                                            .padding()
                                    }
                                }
                                .background(AppColours.customLightGrey)
                                .cornerRadius(30)
                            } else {
                                HStack {
                                    Text(friend.userName)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColours.customLightGreen)
                                        .cornerRadius(30)
                                    
                                    NavigationLink(destination: MessagesView(senderId: Session.shared.getUserID() ?? 0, receiverId: friend.userId, friendName: friend.userName)
                                        .navigationBarBackButtonHidden(true)) {
                                        Image(systemName: "message")
                                                .foregroundColor(AppColours.customBlack)
                                            .font(.custom("Sen", size: 20))
                                            .padding()
                                    }
                                }
                                .background(AppColours.customLightGreen)
                                .cornerRadius(30)
                            }
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
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(groups, id: \.self) { group in
                            Text(group)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppColours.customLightGreen)
                                .cornerRadius(30)
                        }
                    }
                    .padding()
                }
            }
            .background(AppColours.customWhite)
        }
        .task {
            friends = await socialViewModel.fetchFriends()
            groups = await socialViewModel.fetchGroups()
            unreadMessages = await socialViewModel.fetchUnreadMessages(userId: Session.shared.getUserID() ?? 0) ?? []
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
        .onAppear {
            Session.shared.setUserID(19)
        }
}
