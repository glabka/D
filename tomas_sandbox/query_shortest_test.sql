-- SELECT * FROM fridge WHERE use_by_date <= '2015-07-30';
-- SELECT ingredient_name FROM fridge WHERE use_by_date <= '2015-07-30';

-- SELECT ingredient_name FROM fridge WHERE use_by_date <= '2015-07-30';
-- INTERSECT
-- SELECT ingredient_name_r FROM recipes_ingredients WHERE id_recipe_fk=(SELECT id_recipe FROM recipes_list WHERE author='autor receptu' AND recipe_name='jméno pokrmu');


SELECT * FROM fridge WHERE use_by_date <= '2015-07-30';
SELECT * FROM recipes_ingredients;
-- chybí tady to where use_by_date...
-- SELECT * FROM fridge INNER JOIN recipes_ingredients ON fridge.ingredient_name=recipes_ingredients.ingredient_name_r;

-- SELECT * FROM fridge WHERE use_by_date <= '2015-07-30' INNER JOIN recipes_ingredients ON fridge.ingredient_name=recipes_ingredients.ingredient_name_r;


-- pokus prvni udelat kartezsky soucin a pak to vybrat pomoci where
-- toto je funkcni
SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30';

-- kolikrat je jidlo obsazene v nejakem receptu v lednicce s datem mensim nez neco...
SELECT COUNT(*) FROM (SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30') AS T;

-- kolikrat je jidlo v receptu v lednicce s datem mensim nez neco...
-- SELECT id_recipe_fk,COUNT(*) FROM (SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30') AS T GROUP BY id_recipe_fk;
SELECT id_recipe_fk,COUNT(*) AS COUNT FROM (
    /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
    SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30'
    ) AS T GROUP BY id_recipe_fk;

-- získám největší číslo, tj. kolik jídel z ledničky se vyskytlo v receptu, jehož ingredience jsou nejčastěji v ledničce atd. ...
/* select max number froum COUNT */
SELECT id_recipe_fk, MAX(COUNT) AS MAX_COUNT FROM (
    SELECT id_recipe_fk,COUNT(*) AS COUNT FROM (
        /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
        SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30'
    ) AS T GROUP BY id_recipe_fk
) as T2;


-- SET @MAX_COUNT := (SELECT id_recipe_fk,MAX(COUNT) AS MAX_COUNT FROM (
--     SELECT id_recipe_fk,COUNT(*) AS COUNT FROM (
--         /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
--         SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30'
--     ) AS T GROUP BY id_recipe_fk
-- ) AS T2);


/* Matching "id_recipe_fk" with "recipe_name" and "author" */
SELECT * FROM recipes_list JOIN
    /*Finding out id_recipe_fk of recipes with most ingredients in fridge matching constrains.*/
    (SELECT id_recipe_fk,MAX(COUNT) AS MAX_COUNT FROM (
        /*Counting number of ingredients of propriate dates contained at the same time in fridge and recipe*/
        SELECT id_recipe_fk, COUNT(*) AS COUNT FROM (
            /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
            SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30'
        ) AS T GROUP BY id_recipe_fk
    ) AS T2) as T3
ON (id_recipe=id_recipe_fk);


-- MOJE POZN.: toto už by bylo použitelné, až na to, že MAX vezme asi první MAX hodnotu, ale já bych měl najít
-- všechny a v případě, že jichbude víc, vzít ten s abecedně dřívějším jménem
/* Matching "id_recipe_fk" with "recipe_name" and "author" */
SELECT recipe_name,author FROM recipes_list JOIN
    /*Finding out id_recipe_fk of recipes with most ingredients in fridge matching constrains.*/
    (SELECT id_recipe_fk,MAX(COUNT) AS MAX_COUNT FROM (
        /*Counting number of ingredients of propriate dates contained at the same time in fridge and recipe*/
        SELECT id_recipe_fk, COUNT(*) AS COUNT FROM (
            /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
            SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '2015-07-30'
        ) AS T GROUP BY id_recipe_fk
    ) AS T2) as T3
ON (id_recipe=id_recipe_fk);

-- MOJE POZN.: měl bych udělat JOIN mezi recepes_list a těmi počty pro ty recepty, pak to seředit zaprvé podle
-- velikosti MAX a potom podle abecedy a z toho vybrat první...
