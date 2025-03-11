import SwiftUI
import PostgresClientKit
import Foundation

struct MessagesView: View {
    @StateObject private var messagesViewModel: MessagesViewModel
    @State private var timer: Timer?
    @Namespace private var bottomId //need this so it sticks to to bottom
    private let senderId: Int
    private let receiverId: Int
    private let friendName: String
    
    
    init(senderId: Int, receiverId: Int, friendName: String) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.friendName = friendName
        _messagesViewModel = StateObject(wrappedValue: MessagesViewModel(senderId: senderId, receiverId: receiverId, friendName: friendName))
    }
    
    var body: some View {
        ZStack {
            AppColours.customWhite.ignoresSafeArea()
            VStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: AppColours.customLightGreen, location: 0.0),
                            .init(color: AppColours.customLightGreen, location: 0.9),
                            .init(color: AppColours.customWhite, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    Text(friendName)
                        .foregroundColor(AppColours.customBlack)
                        .font(.custom("Sen", size: 32))
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
                if messagesViewModel.isLoading {
                    ProgressView("Loading messages")
                }
                else if let errorMessage = messagesViewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        
                        //great for testing, likely won't occur when in use
                        Button("Try Again") {
                            Task {
                                await messagesViewModel.loadMessages()
                            }
                        }
                        .padding()
                    }
                }
                else {
                    ScrollViewReader { position in
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Array(messagesViewModel.messages.enumerated()), id: \.offset) { index, message in
                                    let isLastFromSender = messagesViewModel.isLastMessage(at: index, senderId: message.senderId)
                                    
                                    MessageBubbleView(
                                        messageText: message.messageText,
                                        isFromCurrentUser: message.senderId == senderId,
                                        messageTimeSent: message.messageTimeSent,
                                        showMessageTime: isLastFromSender || messagesViewModel.visibleTimestamps.contains(index)
                                    )
                                    .gesture(
                                        DragGesture(minimumDistance: 20)
                                            .onEnded { value in
                                                if abs(value.translation.width) > abs(value.translation.height) {
                                                    messagesViewModel.toggleMessageTime(for: index)
                                                }
                                            }
                                    )
                                }
                                //create a tiny object and force it to the bottom
                                Color.clear
                                    .frame(height: 1)
                                    .id(bottomId)
                            }
                            .padding(.horizontal, 10)
                        }
                        .background(AppColours.customWhite)
                        //make it move to the bottom as fast as possible
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                position.scrollTo(bottomId, anchor: .bottom)
                            }
                        }
                        .onChange(of: messagesViewModel.messages.count) { _, _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                position.scrollTo(bottomId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                MessageInputView(messageText: $messagesViewModel.messageText) {
                    Task {
                        await messagesViewModel.sendMessage(
                            senderId: senderId,
                            receiverId: receiverId,
                            messageText: messagesViewModel.messageText,
                            messageTimeSent: DateFormat.dateFormatDayAndTime(Date())
                        )
                        messagesViewModel.messageText = ""
                        await messagesViewModel.loadMessages()
                    }
                }
                .background(AppColours.customLightGreen)
                
            }
            .task {
                await messagesViewModel.loadMessages()
            }
            .onAppear {
                //check if theres messages every 5 seconds.
                timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                    Task {
                        await messagesViewModel.checkForNewMessages()
                    }
                }
                if let timer = timer {
                    RunLoop.main.add(timer, forMode: .common)
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .overlay(
                GeometryReader { geometry in
                    CustomBackButton()
                        .position(x: 25, y: 10)
                }
            )
        }
    }
}

//these are so much better than #Previews, never used due to needed more work, but much more practical
struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MessagesView(senderId: 1, receiverId: 2, friendName: "One")
        }
    }
}
