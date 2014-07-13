/* Add the reviewer Roger Ebert to your database, with an rID of 209. */
insert into Reviewer values(209, 'Roger Ebert');

/* Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into rating 
select Reviewer.rID, Movie.mID, 5, Null
from Reviewer, Movie
where Reviewer.name='James Cameron';

/* For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) */
update Movie
set year=year+25
where Movie.mID in (select mID 
from (select avg(Rating.stars) a, mID
from Rating
group by Rating.mID) A
where A.a>=4);

/* Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
delete from rating 
where mID in (select mID from Movie where year<1970 or year>2000) and stars in (select stars from Rating where stars<4);

