-- Smazání tabulek, aby se odstranil jejich obsah a jejich opětovné vytvoření.
-- Mažu je, protože nešlo použít TRUNCATE na tabulku recipes_list, protože z ní je brán cizí klíč

DROP TABLE IF EXISTS fridge;
DROP TABLE IF EXISTS recipes_ingredients; -- frist removing table with foreign key
DROP TABLE IF EXISTS recipes_list;

CREATE TABLE IF NOT EXISTS fridge(
    id_food INT NOT NULL AUTO_INCREMENT,
    ingredient_name VARCHAR(100) NOT NULL, /*POZN MOJE.: snad to bude stačit, ale možná existuje řešení se stringem bez maximální velikosti*/
    weight_g INT NOT NULL,  /* weight in grams*/
    use_by_date DATE NOT NULL,
    shop_name VARCHAR(100),
    PRIMARY KEY (id_food)
);

CREATE TABLE IF NOT EXISTS recipes_list(
    id_recipe INT NOT NULL AUTO_INCREMENT,
    recipe_name VARCHAR(100) NOT NULL,
    author_first_name VARCHAR(100),
    author_last_name VARCHAR(100),
    PRIMARY KEY(id_recipe),
    CONSTRAINT constraint_unique UNIQUE (recipe_name, author_first_name, author_last_name) /*There can be only one recipe of particular name by one author */
);


CREATE TABLE IF NOT EXISTS recipes_ingredients(
    id_recipe_fk INT,
    ingredient_name_r VARCHAR(100) NOT NULL, /* r == recipes*/
    weight_g_r INT NOT NULL,
    FOREIGN KEY (id_recipe_fk)      /*POZN MOJE.: možná tady bude potřeba dát ještě něco jako UPDATE CASCADE atd.. Musí to hlavně splňovat ty požadavky jako normální forma 3...*/
        REFERENCES recipes_list(id_recipe)
        ON DELETE CASCADE,
    PRIMARY KEY(id_recipe_fk,ingredient_name_r)
);

-- vkládat

-- inserting food to fridge
INSERT INTO fridge VALUES(NULL, 'tomatos', 200, '2015-06-01', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'potato', 1000, '2015-06-22', 'Billa');
INSERT INTO fridge VALUES(NULL, 'milk', 350, '2015-05-30', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'butter', 200, '2015-07-05', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'cheese', 200, '2015-06-20', 'Billa');
INSERT INTO fridge VALUES(NULL, 'bananas', 500, '2015-08-15', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'eggs', 150, '2015-09-03', 'Billa');
INSERT INTO fridge VALUES(NULL, 'yoghurt', 10, '2015-08-22', 'Billa');
INSERT INTO fridge VALUES(NULL, 'mushrooms', 320, '2015-12-01', 'Albert');
INSERT INTO fridge VALUES(NULL, 'beef', 50, '2015-07-14', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'ham', 200, '2015-06-4', 'Albert');
INSERT INTO fridge VALUES(NULL, 'ketchup', 400, '2014-01-20', 'Albert');
-- duplicated food names
INSERT INTO fridge VALUES(NULL, 'milk', 2000, '2015-09-11', 'Billa');
INSERT INTO fridge VALUES(NULL, 'butter', 150, '2015-09-22', 'TESCO');
INSERT INTO fridge VALUES(NULL, 'yoghurt', 150, '2015-06-12', 'Albert');
INSERT INTO fridge VALUES(NULL, 'tomatos', 100, '2015-10-07', 'Billa');

-- inserting recipes to recipes_list
INSERT INTO recipes_list VALUES(NULL, 'hamburger', 'Herr', 'Hamburger');
INSERT INTO recipes_list VALUES(NULL, 'steak', NULL, NULL);
INSERT INTO recipes_list VALUES(NULL, 'bread with cheese', 'Kenneth', 'McAvoy');
INSERT INTO recipes_list VALUES(NULL, 'ham and eggs', 'Kenneth', 'McAvoy');
INSERT INTO recipes_list VALUES(NULL, 'bread with butter', 'Conan', 'Kendrick');
INSERT INTO recipes_list VALUES(NULL, 'bread with butter', 'Kenneth', 'McAvoy');

-- inserting ingredients required for recipes into recipes_ingredients
-- Hamburger, Herr Hamburger
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author_first_name='Herr' AND author_last_name='Hamburger'), /* getting foreign key from recipews_list. columns recipe_name and author_first_name and author_last_name are uniqe. */
    'tomatos', 10);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author_first_name='Herr' AND author_last_name='Hamburger'),
    'ketchup', 20);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author_first_name='Herr' AND author_last_name='Hamburger'),
    'beef', 200);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author_first_name='Herr' AND author_last_name='Hamburger'),
    'mustard', 5);
-- ham and eggs, Kenneth
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='ham and eggs' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'eggs', 200);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='ham and eggs' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'ham', 100);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='ham and eggs' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'oil', 10);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='ham and eggs' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'ketchup', 15);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='ham and eggs' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'butter', 10);
-- steak, NULL
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='steak' AND author_first_name IS NULL AND author_last_name IS NULL),
    'beaf', 10);
-- bread with cheese, Kenneth
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with cheese' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'bread', 100);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with cheese' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'cheese', 20);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with cheese' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'butter', 10);
-- 'bread with butter', 'Kendrick'
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with butter' AND author_first_name='Conan' AND author_last_name='Kendrick'),
    'bread', 100);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with butter' AND author_first_name='Conan' AND author_last_name='Kendrick'),
    'butter', 10);
-- 'bread with butter', 'Kenneth'
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with butter' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'bread', 90);
INSERT INTO recipes_ingredients VALUES(
    (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with butter' AND author_first_name='Kenneth' AND author_last_name='McAvoy'),
    'butter', 15);
