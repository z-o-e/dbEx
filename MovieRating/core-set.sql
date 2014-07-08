/* Find the titles of all movies directed by Steven Spielberg.  */
select title
from movie
where director = "Steven Spielberg";

/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
select distinct year
from movie, rating
where movie.mID = rating.mID and stars>3
order by year;

/* Find the titles of all movies that have no ratings.  */
select title 
from movie
where mID not in (select mID from rating);

/* Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.  */
select distinct name
from rating join reviewer using(rID)
where ratingDate is null;


/* Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.  */
select name, title, stars, ratingDate
from movie, rating, reviewer
where movie.mID = rating.mID and rating.rID = reviewer.rID
order by name, title, stars;

/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.  */
select name, title
from 
(select * from rating) R1,  (select * from rating) R2, reviewer, movie
where R1.rID = R2.rID and R1.mID = R2.mID and R1.ratingDate < R2.ratingDate and R1.stars < R2.stars and R1.rID = reviewer.rID and R1.mID = movie.mID;

/* For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.  */
select title, R.stars
from (select mID, max(stars) stars
from rating
group by mID) R, movie
where R.mID = movie.mID
order by title;

/* For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.  */
select title, R.spread
from (select mID, (max(stars)-min(stars)) spread
from rating
group by mID) R, movie
where R.mID = movie.mID
order by spread desc, title;

/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)  */
select abs(avg(A.stars) - avg(B.stars))
	from (select *
		from(select mID, avg(stars) stars
			from rating
			group by mID) avgEach 
		join movie using(mID)) A,
		(select *
			from(select mID, avg(stars) stars
				from rating
				group by mID) avgEach join movie using(mID)) B
where A.year>1980 and B.year<1980;

