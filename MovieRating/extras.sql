/* Find the names of all reviewers who rated Gone with the Wind.  */
select distinct name
from movie, rating, reviewer
where title="Gone with the Wind" and movie.mID=rating.mID and rating.rID=reviewer.rID;

/* For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.  */
select distinct name, title, stars
from (movie join rating using(mID)) join reviewer using(rID)
where director=name;

/* Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)  */
select title from movie
union
select name from reviewer;

/* Find the titles of all movies not reviewed by Chris Jackson.  */
select title
from movie 
where title not in (select title
				from (select *
							from movie join rating using(mID) join reviewer using(rID) ) A
				where A.name = "Chris Jackson");
				
/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
select distinct A.name, B.name
from (select * 
			from (movie join rating using(mID)) join reviewer using(rID) )A, 
		(select * 
			from (movie join rating using(mID)) join reviewer using(rID) )B
where A.name<B.name and A.mID=B.mID
order by A.name, B.name;

/* For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
select name, title, stars
from  (select * from (movie join rating using(mID)) join reviewer using(rID) ) A
where stars = (select min(stars) from rating);

/* List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.  */
select title, avg(stars) avgS
from movie join rating using(mID)
group by title
order by avgS desc, title;

/* Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)  */
select name
from rating join reviewer using(rID)
group by name having count(name)>2;

/* Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)  */
select title, director 
from movie
where director in (select director
								from movie
							  group by director
							  having count(title)>1)
order by director, title;

/* Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)  */
select *
from (select title, avg(stars) avgS
			from movie join rating using(mID)
		  group by movie.mID) A
where A.avgS >= all(select avgS from (select title, avg(stars) avgS
												from movie join rating using(mID)
		  										group by movie.mID) B);
		  										
/* Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
Note: Your queries are executed using SQLite, so you must conform to the SQL constructs supported by SQLite.	 */	  			select *
from (select title, avg(stars) avgS
			from movie join rating using(mID)
		  group by movie.mID) A
where A.avgS <= all(select avgS from (select title, avg(stars) avgS
												from movie join rating using(mID)
		  										group by movie.mID) B);

/* For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.  */
select A.director, A.stars
from
(select director, stars
from (reviewer join rating using(rID)) join movie using(mID)) A,
where A.stars >= any (select director, stars
from (reviewer join rating using(rID)) join movie) B);

/* For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.  */
select C.director, C.title, max(C.stars)
from 
(select director, title, stars
from reviewer join rating using(rID) join movie using(mID)
where director is not null) C
group by C.director;
