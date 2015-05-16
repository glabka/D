
function sql_insert_recipe {
    # MOJE POZN.: dodělej kontrolu vstupu...

    # echo "////" # debug
    parms="$1" # parameters
    # echo "$parms" # debug
    # echo "........." # debug
    read -r name <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r author <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line

    # printing out first insert command
    echo "-- one recipe:"
    # if author is not empty string
    if [ -n "$author" ];
        then
        echo "INSERT INTO recipes_list VALUES(NULL, '$name', '$author');"
    else
        echo "INSERT INTO recipes_list VALUES(NULL, '$name', NULL);"
    fi


    # reading ingredients and weights
    ingridient_boolean="TRUE";
    # reading first ingredient - to initialize parms_recipes_ingredients
    while read -r line
    do
        if [ "$ingridient_boolean" = "TRUE" ];
            then
            # ingeredient
            # if author is not empty string
            if [ -n "$author" ];
                then
                echo "INSERT INTO recipes_ingredients VALUES((SELECT id_recipe FROM recipes_list WHERE recipe_name='$name' AND author='$author'), '$line'" #printing out first part of command
            else
                echo "INSERT INTO recipes_ingredients VALUES((SELECT id_recipe FROM recipes_list WHERE recipe_name='$name' AND author IS NULL), '$line'" #printing out first part of command
            fi
            ingridient_boolean="FALSE"
        else
        # weight
        # MOJE POZN.: zkontroluj, zda to je int

            echo ", $line);"
            ingridient_boolean="TRUE";
        fi
    done <<< "$parms"


    # místo tohoto echa si to budu přidávat do tmp souboru možná a pokud to proběhne dobře,
    # tak z tohoto tmp souboru to spustím, ať se to vykoná v databázi

    # echo "insert ... ${parms_recipes_ingredients}"

    # if author is null (prázdné...) pak IS NULL, jinak author=cemu...

    # echo "INSERT INTO recipes_ingredients VALUES(
    #     (SELECT id_recipe FROM recipes_list WHERE recipe_name='$name' AND author IS NULL),
    #     '', 10);"

}

cat recept1.txt # debug
sql_insert_file=$( mktemp )
# echo "sql_insert_file == $sql_insert_file" # debug

IFS= # To make sure this shell variable won't affect "read" command
while read -r line
do
	if [ ! -n "$line" ];
		then
		break
	fi
    # echo "$line"
	tmp=$( tr ',' '\n' <<< "$line" )
	# echo "$tmp"
	# echo "..........."

    sql_insert_recipe "$tmp" >> "$sql_insert_file"

done <<< $( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/[ \t]*,[ \t]*/,/g' recept1.txt ) # first delete spaces/tabs leading and ending spaces/tabs, after that spaces/tabs around commas

cat "$sql_insert_file" # debug
rm "$sql_insert_file"
