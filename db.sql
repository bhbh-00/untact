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
    regDate DATETIME NOT NULL,`untact``untact`
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
loginId = "user1",
loginPw = "user1",
`name` = "user1",
nickname = "user1",
cellphoneNo = "01012341234",
email = "jangka512@gmail.com";

# 게시물 테이블에 회원번호 칼럼 추가
ALTER TABLE article ADD COLUMN memberId`untact` INT(10) UNSIGNED NOT NULL AFTER updateDate;

SELECT * FROM article;

INSERT INTO article
(regDate, updateDate, memberId, title, `body`)
SELECT NOW(), NOW(), FLOOR(RAND() * 2) + 1, CONCAT('제목_', FLOOR(RAND() * 1000) + 1), CONCAT('내용_', FLOOR(RAND() * 1000) + 1)
FROM article;

SELECT * FROM article
ORDER BY id ASC
LIMIT 20, 10;

# boardId 테이블 만들기
CREATE TABLE boardId (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(20) UNIQUE NOT NULL,
    `name` CHAR(20) UNIQUE NOT NULL
);

# 게시물 테이블에 boardId 칼럼 추가
ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER updateDate;

# boardId 테스트 데이터 생성
INSERT INTO boardId
SET regDate = NOW(),
updateDate = NOW(),
`code` = "notice",
`name` = "공지사항";

INSERT INTO boardId
SET regDate = NOW(),
updateDate = NOW(),
`code` = "free",
`name` = "자유";

# 게시물에 boardId 번호 랜덤으로 설정하기
UPDATE article
SET boardId = FLOOR(RAND()*2) + 1
WHERE boardId = 0;

