struct SQLRouteQueries{
    
    //inserting user coords
    static let insertUserCoordinates = """
        insert into user_location (
        user_id, user_location) values (
        $1, ST_SetSRID(ST_Point($2, $3), 4326))
    """
    
    //insert passenger into a planned route
    static let insertIntoPlannedRoute = """
        insert into route_groups (group_name, user_id, user_role, user_route_coords, route_day)
        values ($1, $2, $3, ST_SetSRID(ST_Point($4, $5), 4326), $6)
        on conflict (user_id)
        do update set
        group_name = excluded.group_name,
        user_role = excluded.user_role,
        user_route_coords = excluded.user_route_coords,
        route_day = excluded.route_day,
        passenger_included = excluded.passenger_included,
        created_at = excluded.created_at;
    """
    
    //get coordinates for annotations
    static let retrieveUserCoordsFromRouteGroup = """
        select st_x(rg.user_route_coords) as longitude, st_y(rg.user_route_coords) as latitude
        from route_groups rg
        where group_name = $1 and user_role = $2;
    """}
