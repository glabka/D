
-- MOJE POZN.: možná by to mohlo i vytvořit databázi, pokud by neexistovala, ale možná ne...

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

-- primární klíč pro receipes_ingredients by asi mělo být složení primárního klíče receptu a jména suroviny
-- , protože by vždy v recipes_ingredients měl být jen jeden řádek, který podpovídá nějaké ingredienci pro
-- jeden recept.
