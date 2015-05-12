-- MOJE POZN.: možná bych ještě měl smazat obsah těch tabulek předtím, než do nich budu toto
-- vkládat

-- inserting food to fridge
INSERT INTO fridge (NULL, 'tomatos', 200, '2015-06-01');
INSERT INTO fridge (NULL, 'potato', 1000, '2015-06-22');
INSERT INTO fridge (NULL, 'milk', 350, '2015-05-30');
INSERT INTO fridge (NULL, 'butter', 200, '2015-07-05');
INSERT INTO fridge (NULL, 'cheese', 200, '2015-06-20');
INSERT INTO fridge (NULL, 'bananas', 500, '2015-08-15');
INSERT INTO fridge (NULL, 'eggs', 150, '2015-09-03');
INSERT INTO fridge (NULL, 'yoghurt', 10, '2015-08-22');
INSERT INTO fridge (NULL, 'mushrooms', 320, '2015-12-01');
INSERT INTO fridge (NULL, 'beef', 250, '2015-07-14');
INSERT INTO fridge (NULL, 'ham', 200, '2015-06-4');
INSERT INTO fridge (NULL, 'ketchup', 400, '2016-01-20');
-- duplicated food names
INSERT INTO fridge (NULL, 'milk', 2000, '2015-09-11');
INSERT INTO fridge (NULL, 'butter', 150, '2015-09-22');
INSERT INTO fridge (NULL, 'yoghurt', 150, '2015-06-12');
INSERT INTO fridge (NULL, 'tomatos', 100, '2015-10-07');

-- inserting recipes to recipes_list
INSERT INTO recipes_list(NULL, 'hamburger', 'Herr Hamburger');
INSERT INTO recipes_list(NULL, 'svíčková', NULL);
INSERT INTO recipes_list(NULL, 'bread with cheese', NULL);
INSERT INTO recipes_list(NULL, 'ham and eggs', 'Jamie');

-- MOJE POZN.: pozor, asi tento návrh, nebo ta implementace příkazy nesplňují požadavek  na to

--inserting ingredients required for recipes into recipes_ingredients
INSERT INTO recipes_ingredients()
