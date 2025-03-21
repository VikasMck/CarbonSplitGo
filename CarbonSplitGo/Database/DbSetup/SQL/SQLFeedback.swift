struct SQLFeedback{
    
    static let insertFeedback: String = """
        insert into user_feedback (user_id, feedback_rating, feedback_text, feedback_time_sent)
        values ($1, $2, $3, $4);
    """
    
}
