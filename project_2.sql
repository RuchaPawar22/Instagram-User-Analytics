use ig_clone;
show tables;
select * from users;

--  Identify the five oldest users on Instagram from the provided database.
SELECT *
FROM users
ORDER BY users.created_at ASC
LIMIT 5;

-- Inactive user engagement --  Identify users who have never posted a single photo on Instagram.
SELECT users.id, username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

-- Contest winner declartion -- Determine the winner of the contest and provide their details to the team
SELECT u.id, u.username, p.id AS photo_id, COUNT(l.user_id) AS total_likes
FROM users u
JOIN photos p ON u.id = p.user_id
JOIN likes l ON p.id = l.photo_id
GROUP BY u.id, u.username, p.id
ORDER BY total_likes DESC
LIMIT 1;

-- Hashtag Research -- Identify and suggest the top five most commonly used hashtags on the platform.
SELECT tag_name, COUNT(*) AS tag_count
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY tag_count DESC
LIMIT 5;

-- Ad campaign lunch -- Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.
SELECT DAYNAME(created_at) AS registration_day, COUNT(*) AS total_registrations
FROM users
GROUP BY registration_day
ORDER BY total_registrations DESC
LIMIT 1;

-- Investor metrics -- User engagement
-- -- Calculate the average number of posts per user
SELECT COUNT(*) / COUNT(DISTINCT user_id) AS average_posts_per_user
FROM photos;

-- Calculate the total number of photos and total number of users
SELECT COUNT(*) AS total_photos,
       COUNT(DISTINCT user_id) AS total_users
FROM photos;


-- Bot and fake account
-- Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.
SELECT l.user_id, u.username
FROM likes l
JOIN photos p ON l.photo_id = p.id
JOIN users u ON l.user_id = u.id
GROUP BY l.user_id, u.username
HAVING COUNT(DISTINCT p.user_id) >= (SELECT COUNT(*) - 1 FROM users);