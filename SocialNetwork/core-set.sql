/* Find the names of all students who are friends with someone named Gabriel.  */
select name
from Highschooler, Friend
where id=Friend.id1 and id2 in(select id from Highschooler where name='Gabriel');

/* For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.  */
select A.name, A.grade, B.name, B.grade
from (select * from Highschooler, Likes where id = Likes.id1) A,
(select * from Highschooler, Likes where id=Likes.id2) B
where A.id1=B.id1 and A.id2=B.id2 and A.grade-B.grade>1;

/* For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
select distinct h1.name, h1.grade, h2.name, h2.grade
from Likes l1, Likes l2, Highschooler h1, Highschooler h2
where l1.id1=h1.id and l1.id2=h2.id and l1.id1=l2.id2 and l1.id2=l2.id1 and h1.name<h2.name;

/* Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.select  */
select name, grade
from Highschooler
where id not in (select id1 from Likes) and id not in (select id2 from Likes)
order by grade, name;

/* For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.  */
select D.name, D.grade, E.name, E.grade from 
(select * from
(select *
from Likes 
where id2 not in (select id1 from Likes)) C, Highschooler where C.id1=id) D,
(select * from
(select *
from Likes 
where id2 not in (select id1 from Likes)) C, Highschooler where C.id2=id) E
where D.id1=E.id1;

/* Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.  */
select distinct name,grade
from Highschooler, Friend 
where id = id1 and id not in (select distinct f.id1
from Friend f, Highschooler h1, Highschooler h2
where f.id1 = h1.id and f.id2 = h2.id and h1.grade<>h2.grade)
order by grade, name;

/* For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.  */
select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Likes, Friend f1, Friend f2, Highschooler h1, Highschooler h2, Highschooler h3
where (h1.id=Likes.id1 and h2.id=Likes.id2 )
			and h2.id not in (select id2 from Friend where Friend.id1=h1.id)
			and (h1.id=f1.id1 and h3.id=f1.id2) and (h2.id=f2.id1 and h3.id= f2.id2);

/* Find the difference between the number of students in the school and the number of different first names.  */
select count(id)-count(distinct name)
from Highschooler;

/* Find the name and grade of all students who are liked by more than one other student.  */
select name, grade from Highschooler
where id in(select id2 from likes group by id2 having count(id2)>1);
