
CREATE SEQUENCE gameid START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE userid START WITH 1 INCREMENT BY 1;
create sequence commentid start with 1 increment by 1;
create sequence scoreid start with 1 increment by 1;

create table game (
GameID int primary key,
Name varchar2(30) not null,
Author varchar2(30) not null,
Addeddate date,
Url varchar2(256)
);

create table player(
UserID int primary key,
Name varchar2(30) not null,
Password varchar2(30) not null,
Email varchar2(30) not null,
RegistrationDate date not null
);

create table score
(
ScoreID int primary key,
UserID int references player(USERID),
GameID int references GAME(GAMEID),
Score int not null
);

create table commentar(
CommentID int primary key,
UserID int references player(userid),
GameID int references game(gameid),
Commentar varchar2(256) not null
);

create table Rating(
UserID int references player(UserID),
GameID int references game(GameID),
Rating int not null check(rating>=1 and rating <=5),
primary key(userid,gameid)
);


insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Minesweeper','Jan Urda','28.6.2016','minesweeper');
insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Stones','Jan Urda','20.6.2016','/Stones');
insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Hearthstone','Blizzard','28.6.2012','blizzard.com/hearthstone');
insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Tetris','unknown','28.6.1968','tetris');
insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Angry Birds','Zynga games','14.3.2011','store.google.com');
insert into game(gameid,name,author,addeddate,url) values (gameid.nextval,'Snake II','Nokia','25.8.2000','nokia.com');


insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Ferko','1234','Ferko@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Juraj','1234','Ferko@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Alfonz','asd','Alfonz@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Ferko123','password','Ferko123@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Anna','password','Anna@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Zuzka','1234','zuzka@gmail.com','28.6.2016');
insert into player(userid,name,password,email,registrationdate) values (userid.nextval,'Mirko','1234','mirko@gmail.com','28.6.2016');



insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,5,5,123);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,1,5,256);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,2,6,39);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,3,7,159);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,4,5,619);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,6,5,1000);
insert into score (scoreid,userid,gameid,score) values( scoreid.nextval,4,5,0);

insert into rating (userid,gameid,rating) values(5,5,4);
insert into rating (userid,gameid,rating) values(5,5,1);
insert into rating (userid,gameid,rating) values(1,6,4);
insert into rating (userid,gameid,rating) values(3,9,5);
insert into rating (userid,gameid,rating) values(3,6,5);
insert into rating (userid,gameid,rating) values(4,5,4);
insert into rating (userid,gameid,rating) values(5,6,1);
insert into rating (userid,gameid,rating) values(6,7,3);
insert into rating (userid,gameid,rating) values(7,8,5);


insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,5,5,4);
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,1,6,'dobra');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,3,9,'zla');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,3,6,'dobra');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,4,5,'dobra');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,5,6,'dobra');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,6,7,'dobra');
insert into commentar (commentid,userid,gameid,commentar) values(commentid.nextval,7,8,'dobra');

--1. Zoznam hráčov utriedený podľa dátumu registrácie
create view  uloha_1 as
select player.name as name from player order by registrationdate;

--2. Zoznam hier
create view  uloha_2 as
select game.name as name from game;

--3. Zoznam hier s komentármi a menami používateľov
create view  uloha_3 as
select game.name as game_name,commentar.commentar as comentar,player.name as player_name from game join commentar on game.gameid = commentar.gameid join player on commentar.USERID = player.userid;

--4. Hráč s najdlhším menom
create view  uloha_4 as
select player.name as name,length(player.name) as length from player where length(player.name) = (select max(length ) from (select length(player.name)length from player));

--5. Zoznam hier, ktoré nehral nikto (nemajú záznam v Score)
create view  uloha_5 as
select game.name as name from game left join score on score.GAMEID = game.GAMEID where score is null;

--6.Zoznam používateľov, ktorí nehodnotili žiadnu hru
create view  uloha_6 as
select player.name as name from player  left join rating on rating.USERID = player.USERID where rating.rating is null;

--7.Zoznam používateľov, ktorí nehodnotili jednu konkrétnu hru (napr. Minesweeper)
create view  uloha_7 as
select player.name as name from rating  right join player on rating.USERID = player.USERID left  join game on rating.GAMEID = game.GAMEID 
where  game.name not like 'Minesweeper' or game.name is null group by  player.name;

--8.Počet hier, počet hráčov, počet komentárov, počet hodnotení
create view  uloha_8 as
select (select count(*) from game) as games,(select count(*)from player)as players,(select count(*)from commentar)as comments,(select count(*)from rating)as ratings  from dual;

--9.Najstaršia hra
create view  uloha_9 as
select game.name as name from game where game.addeddate = (select min(maxdate) from (select game.addeddate maxdate   from game));

--10.   Zoznam hier s ich priemerným ratingom a počtom hodnotení
create view  uloha_10 as
select game.name as name,round(avg(rating.rating),2) as avg,count(*) as pocet_hodnoteni from rating join game on rating.GAMEID = game.GAMEID group by game.name;

--11.   Najviac komentované hry
create view  uloha_11 as
select name,count from (select game.name name,count(*) count from game join commentar on game.GAMEID = commentar.GAMEID group by game.name) 
where count = (select max(count) from (select count(*) count from game join commentar on game.GAMEID = commentar.GAMEID group by game.name)) ;

--12.   Zoznam hráčov s ich počtom hraním hier a celkovým skóre, ktoré nahrali 
create view  uloha_12 as
select player.name as name, count(*)  as number_of_games,sum(score.score)as sum_score from player join score on player.USERID = score.userid group by player.name;

--13.   Meno hráča, ktorý hral naposledy hru
create view  uloha_13 as
select * from (select player.name from player join score on score.USERID = player.USERID join game on score.GAMEID = game.GAMEID  order by rownum desc) where rownum =1;

--14.   Počet komentárov pre najobľúbenejšiu hru
create view  uloha_14 as
select count from (select game.name name,count(*) count from game join commentar on game.GAMEID = commentar.GAMEID group by game.name) 
where count = (select max(count) from (select count(*) count from game join commentar on game.GAMEID = commentar.GAMEID group by game.name)) ;

--15.   Mená hráčov s počtom komentárov, ktoré pridali k hrám
create view  uloha_15 as
select player.name,count(*) as count from player join commentar on player.userid = commentar.userid group by player.name;
