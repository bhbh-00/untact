# 데이터베이스 생성
DROP DATABASE IF EXISTS untact;
CREATE DATABASE untact;
USE untact;

# 게시물 테이블 생성
CREATE TABLE article (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    title CHAR(100) NOT NULL,
    `body` TEXT NOT NULL
);

# 게시물, 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = "제목1 입니다.",
`body` = "내용1 입니다.";

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = "제목2 입니다.",
`body` = "내용2 입니다.";

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = "제목3 입니다.",
`body` = "내용3 입니다.";

# 회원 테이블 생성
CREATE TABLE `member` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    loginId CHAR(30) NOT NULL,
    loginPw VARCHAR(100) NOT NULL,
    `name` CHAR(30) NOT NULL,
    `nickname` CHAR(30) NOT NULL,
    `email` CHAR(100) NOT NULL,
    `cellphoneNo` CHAR(20) NOT NULL
);

# 로그인 ID로 검색했을 때
ALTER TABLE `member` ADD UNIQUE INDEX (`loginId`);

# 회원, 테스트 데이터 생성
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = "aaa",
loginPw = "1234",
`name` = "신짱구",
nickname = "짱구",
cellphoneNo = "01012341234",
email = "aaa1234@gmail.com";

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = "bbb",
loginPw = "4321",
`name` = "김철수",
nickname = "촬스",
cellphoneNo = "01077778888",
email = "bbb4321@gmail.com";

# 게시물 테이블에 회원번호 칼럼 추가
ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

# 기존 게시물의 작성자를 회원1로 지정
UPDATE article
SET memberId = 1
WHERE memberId = 0;

SELECT * FROM article;

# 테스트 게시물 생성, memberId 랜덤, 제목, 내용 랜덤
INSERT INTO article
(regDate, updateDate, memberId, title, `body`)
SELECT NOW(), NOW(), FLOOR(RAND() * 2) + 1, CONCAT('제목_', FLOOR(RAND() * 1000) + 1), CONCAT('내용_', FLOOR(RAND() * 1000) + 1)
FROM article;

SELECT * FROM `member`;

# 게시판 별 리스팅(board) 테이블 생성
CREATE TABLE board (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(20) UNIQUE NOT NULL,
    `name` CHAR(20) UNIQUE NOT NULL
);

SELECT * FROM board;

# 게시판 별 리스팅 테스트 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = "notice",
`name` = "공지사항";

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = "free",
`name` = "자유";

# 게시물 테이블에 boardId 칼럼 추가
ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER updateDate;

SELECT * FROM article;

# 게시물 테이블에 boardId  랜덤 번호 생성
UPDATE article
SET boardId = FLOOR(RAND() * 2) + 1
WHERE boardId = 0;

# 댓글 테이블 생성
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    articleId INT(10) UNSIGNED NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    `body` TEXT NOT NULL
);

SELECT * FROM reply;

# 댓글 테스트 데이터 생성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
articleId = 1,
memberId= 1,
`body` = "댓글1 입니다.";

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
articleId = 2,
memberId= 1,
`body` = "댓글1 입니다.";

SELECT * FROM reply;

UPDATE reply
SET `body` = "새로운 댓글입니다."
WHERE articleId = 1;