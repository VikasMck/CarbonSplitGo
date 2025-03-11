import Foundation

@MainActor
class MessagesViewModel: ObservableObject {
    @Published var messages: [(messageText: String, messageTimeSent: String, senderId: Int, receiverId: Int)] = []
    @Published var messageText: String = ""
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    @Published var visibleTimestamps: Set<Int> = []
    
    private let senderId: Int
    private let receiverId: Int
    private let friendName: String
    
    init(senderId: Int, receiverId: Int, friendName: String) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.friendName = friendName
    }
    
    //get the last message so the time is always shown
    func isLastMessage(at index: Int, senderId: Int) -> Bool {
        guard index < messages.count else { return false }
        
        let message = messages[index]
        
        if message.senderId != senderId {
            return false
        }
        
        for i in (index + 1)..<messages.count {
            if messages[i].senderId == senderId {
                return false
            }
        }
        return true // This is the last message from this sender
    }

    
    func toggleMessageTime(for index: Int) {
        if visibleTimestamps.contains(index) {
            visibleTimestamps.remove(index)
        }
        else {
            visibleTimestamps.insert(index)
        }
    }
    
    //needed to introduce this as without it is gets jittery, and not fun to use
    func loadMessages() async {
        isLoading = true
        errorMessage = nil
        
        let fetchedMessages = await fetchMessages(senderId: senderId, receiverId: receiverId)
        
        DispatchQueue.main.async {
            self.messages = fetchedMessages ?? []
            
            if fetchedMessages == nil {
                self.errorMessage = "Error loading messages"
            }
            
            self.isLoading = false
        }
    }
    
    func fetchMessages(senderId: Int, receiverId: Int) async -> [(messageText: String, messageTimeSent: String, senderId: Int, receiverId: Int)]? {
        do {
            let messages = try MessagesQueries.retrieveMessagesFromDb(senderId: senderId, receiverId: receiverId)
            
            guard !messages.isEmpty else {
                print("Error, no messages found between user \(senderId) and friend \(receiverId).")
                return []
            }
            
            return messages.map { (messageText: $0.messageText, messageTimeSent: $0.messageTimeSent, senderId: $0.senderId, receiverId: $0.receiverId) }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error retrieving messages: \(error.localizedDescription)"
            }
            return nil
        }
    }
    
    func sendMessage(senderId: Int, receiverId: Int, messageText: String, messageTimeSent: String) async {
        do {
            try await MessagesQueries.sendMessageToDb(
                senderId: senderId,
                receiverId: receiverId,
                messageText: messageText,
                messageTimeSent: messageTimeSent
            )
        } catch {
            self.errorMessage = "Error when sending a message: \(error.localizedDescription)"
        }
        
    }
    
    //so I could refresh only with new messages
    func checkForNewMessages() async {
        let currentMessageCount = messages.count
        
        let wasLoading = isLoading
        isLoading = false
        await loadMessages()
        isLoading = wasLoading
        
        if messages.count > currentMessageCount {
            //this if true triggers a UI update. craaaazy
        }
    }

}
