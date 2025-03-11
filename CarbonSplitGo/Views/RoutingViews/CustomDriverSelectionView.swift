import SwiftUI

struct CustomDriverSelectionView: View {
    let userId: Int
    let userName: String
    let groupName: String
    let routeDay: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Driver: \(userName)")
                    .font(.custom("Sen", size: 18))
                    .foregroundColor(AppColours.customDarkGrey)
                    .padding(.bottom, 10)
                Text("Group: \(groupName)")
                    .font(.custom("Sen", size: 18))
                    .foregroundColor(AppColours.customDarkGrey)
            }
            Spacer()
            
            Text((routeDay.suffix(5)))
                .font(.custom("Sen", size: 25))
                .foregroundColor(AppColours.customDarkGreen)
            
            Spacer()
            
            Button(action: {
                //later
            }) {
                
                NavigationLink(destination: MessagesView(senderId: Session.shared.getUserID() ?? 0, receiverId: userId, friendName: userName)
                    .navigationBarBackButtonHidden(true)) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: 25))
                }                            

            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColours.customWhite)
        .cornerRadius(15)
        .shadow(color: AppColours.customDarkGreen.opacity(0.5), radius: 5, x: 0, y: 0)
        .padding(.horizontal)
    }
}
#Preview {
    CustomDriverSelectionView(userId: 1, userName: "Admin", groupName: "Mastercard", routeDay: "22/02/2025 10:30")
}
