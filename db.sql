-- Выбрать имена и фамилии студентов, успешно сдавших экзамен, упорядоченных по результату экзамена (отличники первые в результате)
-- Посчитать количество студентов, успешно сдавших экзамен на 4 и 5
-- Посчитать количество студентов, сдавших экзамен “автоматом” (нет записи в таблице exam_result но есть положительный результат в таблице student_result)
-- Посчитать средний балл студентов по предмету с наименованием “Системы управления базами данных”
-- Выбрать имена и фамилии студентов, не сдававших экхзамен по предмету “Теория графов” (2 вида запроса)
-- Выбрать идентификатор преподавателей, читающих лекции по больше чем по 2 предметам
-- Выбрать идентификатор и фамилии студентов, пересдававших хотя бы 1 предмет
-- Вывести имена и фамилии 5 студентов с максимальными оценками
-- Вывести фамилию преподавателя, у которого наилучшие результаты по его предметам
-- Вывести успеваемость студентов по годам по предмету “Математическая статистика”

CREATE DATABASE `students`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE students;
CREATE TABLE `student` (
  `id` int(11) unsigned NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  -- `birth_date` date NOT NULL,
  -- `sex` bit(1) NOT NULL,
  -- `hostel_live` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Предмет
CREATE TABLE `training_course` (
  `id` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  `name` VARCHAR(50) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- Преподаватель
CREATE TABLE `teacher` (
  `id` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  `first_name` VARCHAR(20) NOT NULL,
  `last_name` VARCHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- Исправляем ошибки в таблице student
ALTER TABLE `students`.`student` CHANGE COLUMN `id` `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `students`.`training_course` ADD COLUMN `teacher_id` INT(11) UNSIGNED NOT NULL  AFTER `name` , 
  ADD CONSTRAINT `teacher_fk`
  FOREIGN KEY (`teacher_id` )
  REFERENCES `students`.`teacher` (`id` )
  ON DELETE CASCADE
  ON UPDATE RESTRICT
, ADD INDEX `teacher_fk_idx` (`teacher_id` ASC) ;
CREATE  TABLE `students`.`exam` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `date` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) );

ALTER TABLE `students`.`exam` ADD COLUMN `teacher_id` INT(11) UNSIGNED NOT NULL, 
  ADD CONSTRAINT `exam_teacher_fk`
  FOREIGN KEY (`teacher_id` )
  REFERENCES `students`.`teacher` (`id` )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT
, ADD INDEX `exam_teacher_fk_idx` (`teacher_id` ASC) ;

ALTER TABLE `students`.`exam` ADD COLUMN `training_course_id` INT(11) UNSIGNED NOT NULL, 
  ADD CONSTRAINT `exam_training_course_fk`
  FOREIGN KEY (`training_course_id` )
  REFERENCES `students`.`training_course` (`id` )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT
, ADD INDEX `exam_training_course_fk_idx` (`training_course_id` ASC) ;

CREATE  TABLE `students`.`exam_result` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `teacher_id` INT(11) UNSIGNED NOT NULL ,
  `student_id` INT(11) UNSIGNED NOT NULL ,
  `result` TINYINT NOT NULL ,
  `note` VARCHAR(50) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `exam_result_teacher_fk_idx` (`teacher_id` ASC) ,
  INDEX `exam_result_student_fk_idx` (`student_id` ASC) ,
  CONSTRAINT `exam_result_teacher_fk`
    FOREIGN KEY (`teacher_id` )
    REFERENCES `students`.`teacher` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `exam_result_student_fk`
    FOREIGN KEY (`student_id` )
    REFERENCES `students`.`student` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE  TABLE `students`.`student_result` (
  `student_id` INT(11) UNSIGNED NOT NULL ,
  `training_course_id` INT(11) UNSIGNED NOT NULL ,
  `exam_id` INT(11) UNSIGNED,
  `result` TINYINT NOT NULL ,
  `note` VARCHAR(50) NULL ,
  INDEX `student_result__idx` (`training_course_id` ASC) ,
  INDEX `student_result_student_id_idx` (`student_id` ASC) ,
  CONSTRAINT `student_result_training_course`
    FOREIGN KEY (`training_course_id` )
    REFERENCES `students`.`training_course` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `student_result_student_id`
    FOREIGN KEY (`student_id` )
    REFERENCES `students`.`student` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

ALTER TABLE `students`.`exam_result` ADD COLUMN `exam_id` INT(11) UNSIGNED NOT NULL  AFTER `note` , 
  ADD CONSTRAINT `exam_result_exam_fk`
  FOREIGN KEY (`exam_id` )
  REFERENCES `students`.`exam` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  ADD INDEX `exam_result_exam_fk_idx` (`exam_id` ASC) ;

ALTER TABLE `students`.`student_result` 
  ADD CONSTRAINT `student_result_exam_fk`
  FOREIGN KEY (`exam_id` )
  REFERENCES `students`.`exam` (`id` )
, ADD INDEX `student_result_exam_fk_idx` (`exam_id` ASC) ;


-- заполним таблтицу student значениями
INSERT INTO student (id, first_name, last_name)
VALUES (1,  'Вася',    'Пупкин'),
       (2,  'Скуби',   'Ду'),
       (3,  'Спанч',   'Боб'),
       (4,  'Дональд', 'Дак'),
       (26, 'Джеки',   'Чан');

-- заполним таблицу techer значениями 
INSERT INTO teacher (id, first_name, last_name)
VALUES (5, 'Джек',      'Воробей'),
       (6, 'Инспектор', 'Гаджет'),
       (7, 'Майк',      'Вазовски');

-- заполним таблицу training_course значениями 
INSERT INTO training_course (id, name, teacher_id)
VALUES (8, 'Системы управления базами данных', 7),
       (9,  'Теория графов',                   6),
       (10, 'Математическая статистика',       5),
       (27, 'Экономическая теория',            5);

-- заполним таблицу exam значениями 
INSERT INTO exam (id, teacher_id, training_course_id)
VALUES (11, 6, 9),
       (12, 7, 8),
       (13, 5, 10);

-- заполним таблицу exam_result значениями
INSERT INTO exam_result (id, student_id, result, teacher_id, exam_id)
VALUES (14,1,  5, 7, 11),
       (15,2,  4, 7, 11),
       (16,3,  2, 7, 11),
       (17,4,  2, 7, 11),
       (18,1,  5, 6, 12),
       (19,2,  2, 6, 12),
       (20,3,  4, 6, 12),
       (21,4,  4, 6, 12),
       (22,1,  4, 5, 13),
       (23,2,  2, 5, 13),
       (24,3,  4, 5, 13),
       (25,4,  2, 5, 13),
       (28,26, 0, 7, 11),
       (29,26, 0, 6, 12),
       (30,26, 0, 5, 13);

-- заполним таблицу student_result значениями
INSERT INTO student_result (student_id, training_course_id, exam_id, result)
VALUES (1, 9,  12, 5),
       (2, 9,  12, 4),
       (3, 9,  12, 3),
       (4, 9,  12, 3),
       (26,9,  12, 5),
       (1, 8,  11, 5),
       (2, 8,  11, 3),
       (3, 8,  11, 4),
       (4 ,8,  11, 4),
       (26,8,  11, 5),
       (1, 10, 13, 4),
       (2, 10, 13, 3),
       (3, 10, 13, 4),
       (4, 10, 13, 3),
       (26,10, 13, 5);

 

-- 1. Выбрать имена и фамилии студентов, успешно сдавших экзамен, упорядоченных по результату экзамена (отличники первые в результате)
SELECT student.id,student.first_name, student.last_name, exam_result.student_id, exam_result.result
FROM student LEFT JOIN exam_result ON student.id=exam_result.student_id
WHERE result >3
ORDER BY result DESC;


-- 2.Посчитать количество студентов, успешно сдавших экзамен на 4 и 5
SELECT COUNT(exam_result.student_id) FROM exam_result WHERE exam_result.result >=4;


-- 3. Посчитать количество студентов, сдавших экзамен “автоматом” (нет записи в таблице exam_result но есть положительный результат в таблице student_result)
-- за все экзамены
SELECT COUNT(exam_result.student_id) AS Student FROM exam_result WHERE exam_result.result =0;

-- 4. Посчитать средний балл студентов по предмету с наименованием “Системы управления базами данных”
SELECT AVG(exam_result.result) AS AVG
 FROM exam_result WHERE exam_id=12;


-- 5. Выбрать имена и фамилии студентов, не сдававших экхзамен по предмету “Теория графов” (2 вида запроса)

SELECT student.id AS ID,
       student.first_name AS First_name,
       student.last_name AS Last_name,
       exam_result.exam_id AS exam_ID,
       exam_result.result AS result
FROM student INNER JOIN exam_result ON student.id=exam_result.student_id
WHERE exam_result.exam_id=11 AND exam_result.result=2;

-- второй запрос

SELECT student.id AS ID,
       student.first_name AS First_name,
       student.last_name AS Last_name,
       exam_result.exam_id AS exam_ID,
       exam_result.result AS result
FROM (((training_course INNER JOIN exam ON training_course.id = exam.training_course_id)
    INNER JOIN exam_result ON exam.id= exam_result.exam_id)
    INNER JOIN student ON exam_result.student_id = student.id)
WHERE training_course.name='Теория графов' AND exam_result.result=2;

-- 6. Выбрать идентификатор преподавателей, читающих лекции по больше чем по 2 предметам

SELECT teacher_id
    FROM
       (SELECT teacher_id,
               COUNT(id) AS c
       FROM training_course
           GROUP BY teacher_id
           ) as tmp
WHERE tmp.c >=2;

-- 7. Выбрать идентификатор и фамилии студентов, пересдававших хотя бы 1 предмет

SELECT DISTINCT student_result.result AS student_result,
       exam_result.result AS exam_result,
       student.first_name AS first_name,
       student.last_name AS last_name,
       exam_result.student_id AS ID
FROM (student_result INNER JOIN exam_result ON student_result.student_id = exam_result.student_id)
    INNER JOIN student ON student_result.student_id = student.id
WHERE exam_result.result=2 AND student_result.result=3;

-- 8. Вывести имена и фамилии 4 студентов с максимальными оценками

SELECT student_result.student_id AS ID,
       student_result.result AS AVG
    FROM student_result WHERE exam_id=11
    ORDER BY AVG DESC
LIMIT 4;
-- 9.Вывести фамилию преподавателя, у которого наилучшие результаты по его предметам


SELECT teacher.id AS Teacher_ID,
       teacher.first_name AS Teacher_FN,
       teacher.last_name AS Teacher_LN,
       AVG(student_result.result) AS AVG
FROM (teacher INNER JOIN  training_course ON teacher.id = training_course.teacher_id)
    INNER JOIN student_result ON training_course.id =  student_result.training_course_id
 GROUP BY  teacher.id ORDER BY AVG DESC LIMIT 1 ;

-- 10. Вывести успеваемость студентов по предмету “Математическая статистика”

SELECT student.id AS ID,
       student.first_name AS First_name,
       student.last_name AS Last_name,
       student_result.result
FROM student LEFT JOIN student_result ON student.id = student_result.student_id
WHERE student_result.exam_id=13
ORDER BY student_result.result ASC;

