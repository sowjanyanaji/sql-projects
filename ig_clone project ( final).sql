USE ig_clone;
-- Find the 5 oldest users.
select *
from users
order by date(created_at) asc
limit 5;
 -- What day of the week do most users register on? We need to figure out when to schedule an ad campaign.
 SELECT DAYNAME(created_at) AS day_of_week, COUNT(*) AS registrations
FROM users
GROUP BY day_of_week
ORDER BY registrations DESC;

-- We want to target our inactive users with an email campaign.Find the users who have never posted a photo
SELECT * from photos;
select * from users;
SELECT u.id, u.username
FROM users AS u
WHERE u.id NOT IN (SELECT p.user_id FROM photos AS p JOIN users AS u ON u.id = p.user_id);

SELECT * FROM users
WHERE ID NOT IN (SELECT user_id FROM photos);

select u.id,u.username
from users as u
left join photos as p 
on u.id = p.user_id
where p.user_id is null;

-- We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!
SELECT u.username, l.photo_id, COUNT(l.user_id) AS like_count
FROM likes AS l
JOIN photos AS p ON p.id = l.photo_id
JOIN users AS u ON u.id = p.user_id
GROUP BY photo_id
ORDER BY like_count DESC, photo_id ASC;


-- Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*
SELECT count(*)/(SELECT COUNT(*) FROM users) FROM photos;

-- user ranking by postings higher to lower
SELECT
    COUNT(user_id) AS numberofposts,
    user_id,
    DENSE_RANK() OVER (ORDER BY COUNT(user_id) DESC) AS user_rank
FROM photos
GROUP BY user_id
ORDER BY numberofposts DESC;
SELECT 
    users.username, COUNT(photos.image_url) AS userrank
FROM
    users
        JOIN
    photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


-- total numbers of users who have posted at least one time.
SELECT username, COUNT(photos.id) AS TotalUsersWithPosts
FROM photos
INNER JOIN users ON users.id = photos.user_id
GROUP BY photos.user_id, username;


-- A brand wants to know which hashtags to use in a post ,What are the top 5 most commonly used ?
select tag_name,count(tag_name) as top_5 
from tags as t
join photo_tags as p
on t.id = p.tag_id
group by tag_name
order by top_5 desc
limit 5;

-- We have a small problem with bots on our site...Find users who have liked every single photo on the site.

select username,user_id, count(photo_id) as cnt
from likes
inner join users on id = likes.user_id
group by user_id
having cnt = 257
order by cnt desc ;

SELECT user_id, count(*) as num_of_posts_liked
FROM likes
GROUP BY user_id
HAVING num_of_posts_liked IN (SELECT count(*) FROM photos);

-- Find users who have never commented on a photo.
SELECT u.id, u.username
FROM users AS u
WHERE u.id NOT IN (SELECT user_id FROM comments);

