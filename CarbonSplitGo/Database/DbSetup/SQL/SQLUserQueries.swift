struct SQLUserQueries {
    
    //register a user
    static let insertUser = """
        insert into users (
        user_name, user_email, user_password, user_first_name, user_last_name,
        user_phone_number, user_profile_picture_url, user_date_of_birth,
        user_default_role, is_online, is_verified, verification_token,
        user_saved_co2, user_distance_shared, user_carbon_credits ) 
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
    """
    
    //login
    static let authenticateUser = """
        select user_id from users
        where user_email = $1 and user_password = $2
    """
    
    //delete user
    static let deleteUser = """
        delete from users where user_email = $1;
    """
    
    static let changeUserToOnline = """
    update users set is_online = true where user_email = $1;
    """
    
    static let changeUserToOffline = """
    update users set is_online = false where user_email = $1;
    """


}
