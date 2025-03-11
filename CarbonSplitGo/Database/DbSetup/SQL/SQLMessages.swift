struct SSQLMessages {
    
    static let retrieveMessages: String = """
        select message_text, message_time_sent, sender_id, receiver_id from messages 
        where (sender_id = $1 and receiver_id = $2) or (sender_id = $3 and receiver_id = $4) order by message_time_sent;
    """
    
    static let sendMessage: String = """
        insert into messages (sender_id, receiver_id, message_text, message_time_sent) values ($1, $2, $3, $4);
    """
}
