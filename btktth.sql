DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

CREATE TABLE students (
    student_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    total_debt DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE subjects (
    subject_id VARCHAR(5) PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL,
    credits INT CHECK(credits > 0)
);

CREATE TABLE grades (
    student_id VARCHAR(5),
    subject_id VARCHAR(5),
    score DECIMAL(4,2) CHECK(score BETWEEN 0 AND 10),
    PRIMARY KEY(student_id, subject_id),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE grade_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(5),
    old_score DECIMAL(4,2),
    new_score DECIMAL(4,2),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);

INSERT INTO students(student_id, full_name, total_debt)
VALUES
('SV01', 'Nguyen Van A', 7000000);

INSERT INTO subjects(subject_id, subject_name, credits)
VALUES
('MH01', 'Co So Du Lieu', 3),
('MH02', 'Lap Trinh Java', 4);

-- CÂU 1
DELIMITER //
CREATE TRIGGER tg_check_score
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    IF NEW.score < 0 THEN
        SET NEW.score = 0;
    END IF;

    IF NEW.score > 10 THEN
        SET NEW.score = 10;
    END IF;
END //
DELIMITER ;

-- CÂU 2
START TRANSACTION;

INSERT INTO students(student_id, full_name)
VALUES
('SV02', 'Ha Bich Ngoc');
UPDATE students
SET total_debt = 5000000
WHERE student_id = 'SV02';

COMMIT;

-- CÂU 3
DELIMITER //

CREATE TRIGGER tg_log_grade_update
AFTER UPDATE ON grades
FOR EACH ROW
BEGIN
    INSERT INTO grade_log(student_id, old_score, new_score, change_date)
    VALUES(OLD.student_id, OLD.score, NEW.score,
        NOW()
    );
END //

DELIMITER ;

-- CÂU 4
DELIMITER //

CREATE PROCEDURE sp_pay_tuition()







