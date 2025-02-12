struct SQLSocialQueries {
 
    static let retrieveUserFriends = """
        select u.user_name as friend_name
        from friends f
        join users u on f.friend_id = u.user_id
        where f.user_id = $1
        order by u.user_name asc;
    """
    
    static let retrieveUserGroups = """
        select g.group_name from groups g where user_id = $1;
    """
    
    static let addFriend = """
        insert into friends (user_id, friend_id)
        values ($1, $2), ($3, $4)
        on conflict (user_id, friend_id) do nothing;
    """
    
    static let joinGroup = """
        insert into groups (group_name, user_id)
        values ($1, $2);
    """
    
}
