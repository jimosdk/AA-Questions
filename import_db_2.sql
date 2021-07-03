PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) 
);
INSERT INTO users VALUES(1,'Harry','Potter');
INSERT INTO users VALUES(2,'Ron','Weasley');
INSERT INTO users VALUES(3,'Hagrid','Rubeus');
INSERT INTO users VALUES(4,'Lucius','Malfoi');
INSERT INTO users VALUES(5,'Dobby','Free-elf');
INSERT INTO users VALUES(6,'Hermione','Granger');
INSERT INTO users VALUES(7,'Remus','Lupin');
INSERT INTO users VALUES(8,'Alastor','Moody');
INSERT INTO users VALUES(9,'Minerva','Mcgonagall');
INSERT INTO users VALUES(10,'Albus','Dumbledoore');
INSERT INTO users VALUES(11,'Gilderoy','Lockhart');
INSERT INTO users VALUES(12,'Nymphadora','Tonks');
INSERT INTO users VALUES(13,'Severus','Snape');
INSERT INTO users VALUES(14,'Luna','Lovegood');
CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL ,
    body TEXT,
    author_id INTEGER,

    FOREIGN KEY (author_id) REFERENCES users(id)
);
INSERT INTO questions VALUES(1,'Am i a wizzard,already?','title',1);
INSERT INTO questions VALUES(2,'Is Dobby Free?','title',5);
INSERT INTO questions VALUES(3,'Hogwarts History','Honestly, am I the only person who''s ever bothered to read ''Hogwarts: A History?',6);
INSERT INTO questions VALUES(4,'Does anyone know who Regulus is?','title',1);
INSERT INTO questions VALUES(5,'Magic potions','On which floor is the classroom for magic potions',6);
INSERT INTO questions VALUES(6,'Weird slithering noises in the walls','Has anyone heard of those weird snake like noises at night,they seem to come from the walls',1);
CREATE TABLE question_follows(
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);
INSERT INTO question_follows VALUES(6,2);
INSERT INTO question_follows VALUES(1,2);
INSERT INTO question_follows VALUES(2,2);
INSERT INTO question_follows VALUES(6,3);
INSERT INTO question_follows VALUES(1,1);
INSERT INTO question_follows VALUES(2,1);
INSERT INTO question_follows VALUES(5,1);
INSERT INTO question_follows VALUES(6,1);
CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body TEXT,
    author_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    parent_id INTEGER,
    
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (subject_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);
INSERT INTO replies VALUES(1,'Yer a wizard Harry.',3,1,NULL);
INSERT INTO replies VALUES(2,'No clue...',1,3,NULL);
INSERT INTO replies VALUES(3,'Probably...',2,3,2);
INSERT INTO replies VALUES(4,'No,he is not!',4,2,NULL);
INSERT INTO replies VALUES(5,'Dobby,you are free...',1,2,4);
INSERT INTO replies VALUES(6,'...You will pay for this...',4,2,5);
INSERT INTO replies VALUES(7,'It''s on the third floor ,past the library,third door to the right',3,5,NULL);
INSERT INTO replies VALUES(8,'Oh, my...how terrible!',9,6,NULL);
INSERT INTO replies VALUES(9,'You'' re probably stressed out Harry',14,6,8);
INSERT INTO replies VALUES(10,'At my office at once Potter',13,6,9);
CREATE TABLE question_likes(
    question_id INTEGER,
    user_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO question_likes VALUES(1,6);
INSERT INTO question_likes VALUES(1,2);
INSERT INTO question_likes VALUES(1,3);
INSERT INTO question_likes VALUES(3,5);
INSERT INTO question_likes VALUES(2,6);
INSERT INTO question_likes VALUES(2,1);
COMMIT;
