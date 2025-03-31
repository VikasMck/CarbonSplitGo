create table users(
    user_id serial primary key,
    user_name varchar(50) unique not null,
    user_email varchar(100) unique not null,
    user_password text not null,
    user_first_name varchar(50),
    user_last_name varchar(50),
    is_online boolean default false,
    is_verified boolean default false,
    verification_token text,
    user_phone_number varchar(20),
    user_profile_picture_url text,
    user_date_of_birth date,
    user_default_role varchar(20) default 'passenger',
    user_saved_co2 double precision default 0,
    user_distance_shared double precision default 0,
    user_carbon_credits double precision default 0,
    user_created_at timestamp default now()
);

create table friends (
     user_id int references users(user_id) on delete cascade,
     friend_id int references users(user_id) on delete cascade,
     created_at timestamp default current_timestamp,
     primary key (user_id, friend_id)
);

create table groups (
    group_id serial primary key,
    group_name varchar(255) not null,
    user_id int references users(user_id) on delete cascade,
    created_at timestamp default current_timestamp
);

create table route_groups(
    route_id serial primary key,
    group_name varchar(255) not null,
    user_id  int references users (user_id) on delete cascade,
    user_role varchar(20),
    user_route_coords public.geometry(point, 4326),
    route_day varchar(30),
    passenger_included boolean default true,
    created_at timestamp default current_timestamp
);

create table user_feedback(
    feedback_id serial primary key,
    user_id int references users(user_id) on delete cascade,
    feedback_rating double precision,
    feedback_text text,
    feedback_time_sent varchar(20)
);

create table feedback_unread(
    user_id int references users (user_id) on delete cascade,
    which_driver int references users (user_id) on delete cascade
);

create table messages(
    message_id serial primary key,
    sender_id int references users(user_id) on delete cascade,
    receiver_id int references users(user_id) on delete cascade,
    message_text text,
    message_time_sent varchar(20)
);

create table message_unread(
    user_id int references users (user_id) on delete cascade,
    which_user int references users (user_id) on delete cascade
);
