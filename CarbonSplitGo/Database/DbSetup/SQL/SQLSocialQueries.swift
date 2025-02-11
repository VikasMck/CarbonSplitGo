struct SQLSocialQueries {
 
    static let retrieveUserFriends = """
        select u.user_name as friend_name
        from friends f
        join users u on f.friend_id = u.user_id
        where f.user_id = $1
        order by u.user_name asc;
    """
}
