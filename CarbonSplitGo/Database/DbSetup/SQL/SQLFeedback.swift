struct SQLFeedback{
    
    static let insertFeedback: String = """
        insert into user_feedback (user_id, feedback_rating, feedback_text, feedback_time_sent)
        values ($1, $2, $3, $4);
    """
    
    static let updateFeedbackStatusForDriver: String = """
        insert into feedback_unread (user_id, which_driver) values ($1, $2);
    """
    
    static let retrieveFeedbackForDriver: String = """
        select fu.which_driver, u.user_name from feedback_unread fu join users u on u.user_id = fu.which_driver where fu.user_id = $1;
    """
    
    static let clearFeedbackForDriver: String = """
        delete from feedback_unread where which_driver = $1;
    """
    
}
