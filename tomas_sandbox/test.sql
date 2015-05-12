


-- CREATE TABLE IF NOT EXISTS neco1(
--     id_student INT NOT NULL AUTO_INCREMENT,
--     name VARCHAR(100) NOT NULL,
--     PRIMARY KEY (id_student)
--     );

CREATE TABLE  IF NOT EXISTS parent (
    id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE  IF NOT EXISTS child (
    id INT,
    parent_id INT,
    INDEX par_ind (parent_id),
    FOREIGN KEY (parent_id)
        REFERENCES parent(id)
        ON DELETE CASCADE
);

-- INSERT INTO parent VALUES(1);
-- INSERT INTO child VALUES(101, 1);
-- INSERT INTO parent VALUES(2);
-- INSERT INTO child VALUES(202, 2);



SHOW TABLES;
