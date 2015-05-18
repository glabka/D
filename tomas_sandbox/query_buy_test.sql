--  --query buy <recept>
-- Asi bych měl udělat pravý/levý join tak, abych tam měl všechny jídla z receptu a k nim ty, které
-- jsou v ledničce a pak od sebe nechám odečíst dva sloupce, tj. váha v receptu a váha v ledničce
-- a nechám vypsat to, co je větší než 0.

-- SELECT * FROM fridge RIGHT JOIN (recipes_ingredients WHERE id_recipe_fk=1) AS T ON (fridge.ingredient_name=recipes_ingredients.ingredient_name_r);
-- SELECT * FROM fridge RIGHT JOIN recipes_ingredients ON (fridge.ingredient_name=recipes_ingredients.ingredient_name_r);

SELECT * FROM (fridge RIGHT JOIN recipes_ingredients ON (fridge.ingredient_name=recipes_ingredients.ingredient_name_r)) WHERE id_recipe_fk=1;

-- pozor, chyba, ještě před tím JOINEM bych měl dát group by na stejné jména v ledničce
/*COALESCE = returns firt not-null value*/
SELECT ingredient_name_r,weight_g_r,weight_g,weight_g_r-COALESCE(weight_g,0) FROM (fridge RIGHT JOIN recipes_ingredients ON (fridge.ingredient_name=recipes_ingredients.ingredient_name_r)) WHERE id_recipe_fk=1;

SELECT *,SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name;
-- SELECT id_food, ingredient_name, weight_g, use_by_date, shop_name, SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name;
-- SELECT ingredient_name_r,weight_g_r,weight_g,weight_g_r-COALESCE(weight_g,0) FROM (fridge RIGHT JOIN recipes_ingredients ON (fridge.ingredient_name=recipes_ingredients.ingredient_name_r)) WHERE id_recipe_fk=1;

-- id_recipe_fk => místo toho tam musím nějak zapomponovat jméno receptu...
SELECT ingredient_name_r,weight_g_r,total_weight_g,weight_g_r-COALESCE(total_weight_g,0) FROM (
    (SELECT *,SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
     ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
WHERE id_recipe_fk=1;

-- Asi funkční dotaz, jen je potřeba vybrat řádky, které mají hodnotu "buy" větší než nula
SET @id_recipe_var := (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author='Herr Hamburger');

SELECT ingredient_name_r,weight_g_r,total_weight_g,weight_g_r-COALESCE(total_weight_g,0) AS buy FROM (
    (SELECT *,SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
     ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
WHERE id_recipe_fk=@id_recipe_var;



-- ----------------------------------------------------------------------------------------------------------------------
-- Asi funkční dotaz
SET @id_recipe_var := (SELECT id_recipe FROM recipes_list WHERE recipe_name='bread with butter' AND author='Kendrick');
-- SET @id_recipe_var := (SELECT id_recipe FROM recipes_list WHERE recipe_name='hamburger' AND author='Herr Hamburger');

-- for debug
SELECT ingredient_name_r,weight_g_r,total_weight_g,weight_g_r-COALESCE(total_weight_g,0) AS buy FROM (
    (SELECT *,SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
     ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
WHERE id_recipe_fk=@id_recipe_var;

--
SELECT ingredient_name_r,weight_g_r-COALESCE(total_weight_g,0) AS buy FROM (
    (SELECT *,SUM(weight_g) AS total_weight_g FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
     ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
WHERE id_recipe_fk=@id_recipe_var AND weight_g_r-COALESCE(total_weight_g,0) > 0;
-- ----------------------------------------------------------------------------------------------------------------------
