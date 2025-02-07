struct SQLQueries {
    
    //register a user
    static let insertUser = """
        insert into user_management.users (
        user_name, user_email, user_password, user_first_name, user_last_name,
        user_phone_number, user_profile_picture_url, user_date_of_birth,
        user_default_role, is_active, is_verified, verification_token
        )
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
    """
    
    //login
    static let authenticateUser = """
        select user_id from user_management.users
        where user_email = $1 and user_password = $2
    """
    
    //inserting user coords
    static let insertUserCoordinates = """
        insert into user_management.user_location (
        user_id, user_location) values (
        $1, ST_SetSRID(ST_Point($2, $3), 4326))
    """
    


}
