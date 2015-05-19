SELECT recipe_name FROM recipes_list WHERE author='autor receptu';
SELECT ingredient_name_r, weight_g FROM recipes_ingredients WHERE id_recipe_fk=(SELECT id_recipe FROM recipes_list WHERE author='autor receptu' AND recipe_name='jméno pokrmu');
