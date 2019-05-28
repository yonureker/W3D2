PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  questions_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  reply_id INTEGER,

  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

INSERT INTO users (fname, lname)
VALUES ('first', 'last');
INSERT INTO users (fname, lname)
VALUES ('Greg', 'Wathen');
INSERT INTO users (fname, lname)
VALUES ('Onur', 'Eker');

INSERT INTO questions (title, body, user_id)
VALUES ('Question 1', 'This is the body.', 1);
INSERT INTO questions (title, body, user_id)
VALUES ('What is the meaning of life?', 'I have no idea, so that''s why I am asking. You tell me.', 2);

INSERT INTO question_follows (user_id, questions_id)
VALUES (1, 2);
INSERT INTO question_follows (user_id, questions_id)
VALUES (3, 2);
INSERT INTO question_follows (user_id, questions_id)
VALUES (2, 1);

INSERT INTO replies (body, questions_id, user_id, reply_id)
VALUES ('This is a reply', 1, 1, NULL);
INSERT INTO replies (body, questions_id, user_id, reply_id)
VALUES ('First', 1, 2, 1);
INSERT INTO replies (body, questions_id, user_id, reply_id)
VALUES ('No you aren''t!!!', 1, 3, 2);

INSERT INTO question_likes (user_id, questions_id)
VALUES (2, 2);
INSERT INTO question_likes (user_id, questions_id)
VALUES (3, 1);
