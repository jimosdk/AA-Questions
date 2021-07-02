PRAGMA foreign_keys = ON;
DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;


CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) 
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL ,
    body TEXT,
    author_id INTEGER,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

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

CREATE TABLE question_likes(
    question_id INTEGER,
    user_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



INSERT INTO
    users
    (fname,lname)
VALUES
    ('Harry','Potter'),
    ('Ron','Weasley'),
    ('Rubeus','Hagrid'),
    ('Lucius','Malfoi'),
    ('Dobby',NULL),
    ('Hermione','Granger')
;

INSERT INTO
    questions
    (title,body,author_id)
VALUES
    ('Am i a wizzard,already?','title',
    (SELECT 
        id 
    FROM 
        users 
    WHERE 
        fname = 'Harry')),

    ('Is Dobby Free?','title',
    (SELECT 
        id 
    FROM 
        users 
    WHERE 
        fname = 'Dobby')),

    ('Hogwarts History','Honestly, am I the only person who''s ever bothered to read ''Hogwarts: A History?',
    (SELECT 
        id 
    FROM 
        users 
    WHERE 
        fname = 'Hermione')),

    ('Does anyone know who Regulus is?','title',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'
    ))
;

INSERT INTO
    replies
    (body,author_id,subject_id,parent_id)
VALUES
    ('Yer a wizard Harry.',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Rubeus'),

    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?'),
    NULL),

    ('No clue...',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Hogwarts History'),
    NULL)
;

INSERT INTO
    replies
    (body,author_id,subject_id,parent_id)
VALUES   
    ('Probably...',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Ron'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Hogwarts History'),

    (SELECT
        id
    FROM
        replies
    WHERE
        body = 'No clue...')),
    
    ('No,he is not!',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Lucius'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?'),
    NULL)
;

INSERT INTO
    replies
    (body,author_id,subject_id,parent_id)
VALUES
    ('Dobby,you are free...',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?'),

    (SELECT
        id
    FROM
        replies
    WHERE
        body = 'No,he is not!'))
;


INSERT INTO
    replies
    (body,author_id,subject_id,parent_id)
VALUES
    ('AVADA KEDAVRA!!!',
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Lucius'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?'),
        
    (SELECT
        id
    FROM
        replies
    WHERE
        body = 'Dobby,you are free...'))
;

INSERT INTO 
    question_follows
    (user_id,question_id)
VALUES
    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Hermione'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Ron'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Hermione'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Hogwarts History')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Ron'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Dobby'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Hermione'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    )
    
;

INSERT INTO 
    question_likes
    (user_id,question_id)
VALUES
    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Hermione'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Ron'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Rubeus'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Am i a wizzard,already?')
    ),


    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Dobby'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Hogwarts History')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Hermione'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?')
    ),

    (
    (SELECT
        id
    FROM
        users
    WHERE
        fname = 'Harry'),
    
    (SELECT
        id
    FROM
        questions
    WHERE
        title = 'Is Dobby Free?')
    )

;
