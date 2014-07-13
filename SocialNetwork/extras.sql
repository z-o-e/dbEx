/* For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.  */
select distinct h1.name, h1.grade, h2.name, h2.grade,h3.name, h3.grade 
from Likes l1, Likes l2, Highschooler h1, Highschooler h2, Highschooler h3
where (h1.id=l1.id1 and h2.id=l1.id2)
          and (h3.id=l2.id2 and h2.id=l2.id1)
          and h1.id<>h3.id;

/* Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.  */
select distinct name, grade
from Friend, Highschooler
where id1=id and id1 not in (select distinct id1
from Friend f, Highschooler h1, Highschooler h2
where f.id1 = h1.id and f.id2=h2.id and h1.grade=h2.grade);

/* What is the average number of friends per student? (Your result should be just one number.)  */
select avg(cc) from
(select count(id2) cc
from Friend
group by id2) A, Highschooler;

/* Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.  */
select count(h1.name)
from Highschooler h1, Highschooler h2, Friend
where id1=h1.id and id2=h2.id 
			and (h2.name='Cassandra' or id2 in (select id1 from Highschooler h1, Highschooler h2, Friend where h1.id=id1 and h2.id=id2 and h2.name='Cassandra') ) and h1.name<>'Cassandra';


/* Find the name and grade of the student(s) with the greatest number of friends.  */
select name, grade from 
(select id1, count(id2) cc
from Friend
group by id1)C, Highschooler
where C.cc in (select max(A.ss) from (select count(id2) ss from Friend group by id1) A) and Highschooler.id=C.id1;