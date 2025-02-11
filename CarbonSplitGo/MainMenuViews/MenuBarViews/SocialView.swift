import SwiftUI

struct SocialView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    
//    var userId: Int  Pass this dynamically when creating the view
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Social").font(.largeTitle)
                
             
                Text("Friends").font(.headline)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(socialViewModel.friends, id: \.self) { friend in
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
                        TextField("Add Friend", text: $socialViewModel.addFriend)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                        }
                    }
                    .padding()
                    
                    HStack {
                        TextField("Add Group", text: $socialViewModel.joinGroup)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                socialViewModel.fetchFriends()
            }
        }
    }
}

#Preview {
    SocialView()
}
