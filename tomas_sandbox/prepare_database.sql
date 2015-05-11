
CREATE TABLE IF NOT EXISTS fridge(
    id_food INT NOT NULL AUTO_INCREMENT,
    ingredient_name VARCHAR(100) NOT NULL, /*POZN MOJE.: snad to bude stačit, ale možná existuje řešení se stringem bez maximální velikosti*/
    weight INT NOT NULL,
    use_by_date DATE NOT NULL,
    PRIMARY KEY (id_food)
);

CREATE TABLE IF NOT EXISTS recipes_list(
    id_recipe INT NOT NULL AUTO_INCREMENT,
    recipe_name VARCHAR(100) NOT NULL UNIQUE, /*POZN MOJE.: možná z toho unique slevím*/   
    author VARCHAR(100),
    PRIMARY KEY(id_recipe)
);
