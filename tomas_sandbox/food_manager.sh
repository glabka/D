#!/bin/bash
# parsování vstupů
# Pokud nebudou exitavat příslušné základní tabulky (tj. obsah_ledničky a recepty), tak je vytvoříme

DEBUG_ON="FALSE"

# first parameter is string containing sql commands for execution, rest is parameters for mysql program
function run_sql_var {
    # echo "run_sql_var" # debug
    # echo "\$1 == $1" # debug
    # echo "\${*:2} == ${*:2}" # debug
    if [ -n "${*:2}" ];
        then
        mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" "${*:2}" <<< "$1" # "${*:2}" == passing all parameters but first
    else
        mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" <<< "$1"
    fi    # echo "DONE" >&2 # debug
}

# first parameter is file_name of file containing sql commands for execution, rest is parameters for mysql program
function run_sql {
    # echo "run_sql" # debug
    # echo "\$1 == $1" # debug
    # echo "\${*:2} == ${*:2}" # debug
    if [ -n "${*:2}" ];
        then
        mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" "${*:2}" < "$1" # "${*:2}" == passing all parameters but first
    else
        mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" < "$1"
    fi
    # echo "DONE" >&2 # debug
}

# Add tables requared for proper funcioning of functions insert and query
function prepare_database {
    run_sql prepare_database.sql
    ret_val="$?"
    # MOJE POZN.: udělej něco podle návratové hodnoty...
}

#################################
function sql_insert_recipe {
    # MOJE POZN.: dodělej kontrolu vstupu...

    parms="$1" # parameters
    # echo "$parms" # debug
    # echo "........." # debug
    read -r name <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r author_first_name <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r author_last_name <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line

    # printing out first insert command
    echo "-- one recipe:"
    # if author_first_name is not empty string
    if [ -n "$author_first_name" ];
        then
        printf "INSERT INTO recipes_list VALUES(NULL, '$name', '$author_first_name'"
    else
        printf "INSERT INTO recipes_list VALUES(NULL, '$name', NULL"
    fi
    # if author_last_name is not empty string
    if [ -n "$author_last_name" ];
        then
        echo ", '$author_last_name');"
    else
        echo ", NULL);"
    fi

    # reading ingredients and weights
    ingridient_boolean="TRUE";
    # reading first ingredient - to initialize parms_recipes_ingredients
    while read -r line
    do
        if [ "$ingridient_boolean" = "TRUE" ];
            then
            # ingeredient
            # if author_first_name is not empty string
            if [ -n "$author_first_name" ];
                then
                printf "INSERT INTO recipes_ingredients VALUES((SELECT id_recipe FROM recipes_list WHERE recipe_name='$name' AND author_first_name='$author_first_name'" #printing out first part of command
            else
                printf "INSERT INTO recipes_ingredients VALUES((SELECT id_recipe FROM recipes_list WHERE recipe_name='$name' AND author_first_name IS NULL" #printing out first part of command
            fi
            #if author_last_name is not empty string
            if [ -n "$author_last_name" ];
                then
                printf " AND author_last_name='$author_last_name'"
            else
                printf " AND author_last_name IS NULL"
            fi

            echo "), '$line'"
            ingridient_boolean="FALSE"
        else
        # weight
        # MOJE POZN.: zkontroluj, zda to je int

            echo ", $line);"
            ingridient_boolean="TRUE";
        fi
    done <<< "$parms"
}


function insert_recipes {
    #if doesn't exist normal file fith name $1
    if [ ! -f "$1" ];
        then
        echo "File with name $1 doesn't exist."
        exit 1
    fi

    sql_insert_file=$( mktemp )

    IFS= # To make sure this shell variable won't affect "read" command
    while read -r line
    do
    	if [ ! -n "$line" ];
    		then
    		break
    	fi
    	tmp=$( tr ',' '\n' <<< "$line" )
        sql_insert_recipe "$tmp" >> "$sql_insert_file"    # append to sql_insert_file

    done <<< $( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/[ \t]*,[ \t]*/,/g' "$1" ) # first delete spaces/tabs leading and ending spaces/tabs, after that spaces/tabs around commas


    if [ "$DEBUG_ON" = "TRUE" ];
        then
        echo "Genereted SQL commands:" >&2
        cat "$sql_insert_file" >&2
    fi
    run_sql "$sql_insert_file"
    rm "$sql_insert_file"
}

##################################


function sql_insert_fridge {
    # MOJE POZN.: dodělej kontrolu vstupu...
    # MOJE POZN.: jediné shop_name může být null

    # echo "-- one food:"
    parms="$1" # parameters
    # echo "$parms" # debug
    # echo "........." # debug
    read -r ingredient_name <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r weight_g <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r use_by_date <<< "$parms"
    parms=$( tail -n +2 <<< "$parms" ) # deleting first line (already read). -n +2 == start form second line
    read -r shop_name <<< "$parms"

    # if shop_name is not emplty
    if [ -n "$shop_name" ];
        then
        echo "INSERT INTO fridge VALUES(NULL, '$ingredient_name', $weight_g, '$use_by_date', '$shop_name');"
    else
        echo "INSERT INTO fridge VALUES(NULL, '$ingredient_name', $weight_g, '$use_by_date', NULL);"
    fi

}

function insert_into_fridge {
    #if doesn't exist normal file fith name $1
    if [ ! -f "$1" ];
        then
        echo "File with name $1 doesn't exist."
        exit 1
    fi

    sql_insert_file=$( mktemp )

    IFS= # To make sure this shell variable won't affect "read" command
    while read -r line
    do
    	if [ ! -n "$line" ];
    		then
    		break
    	fi
    	tmp=$( tr ',' '\n' <<< "$line" )
        sql_insert_fridge "$tmp" >> "$sql_insert_file"

    done <<< $( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/[ \t]*,[ \t]*/,/g' "$1" ) # first delete spaces/tabs leading and ending spaces/tabs, after that spaces/tabs around commas

    if [ "$DEBUG_ON" = "TRUE" ];
        then
        echo "Genereted SQL commands:" >&2
        cat "$sql_insert_file" >&2
    fi
    run_sql "$sql_insert_file"
    rm "$sql_insert_file"
}

# $1 option of inserting, $2 file.
function insert {
    if [ "$1" = "recipes" ];
        then
        insert_recipes "$2"
    elif [ "$1" = "fridge" ];
        then
        insert_into_fridge "$2"
    else
        echo "--insert can be used only as \"--insert recipes file_containing_recipe\" or \"--insert fridge file_containing_food\". For more information see help (--help)."
        exit 1 # bad parameters
    fi
}

##############################
###########################

# first parameter is <author>
function query_recipes {
    # echo "query_recipes" # debug
    sql_recipe_names="SELECT recipe_name FROM recipes_list WHERE author='$1';"
    recipe_names=$( run_sql_var "$sql_recipe_names" ) # every line is name of one recipe
    # echo "$recipe_names"
    recipe_names=$( tail -n +2 <<< "$recipe_names" ) # deleting first line == name of column

    echo "Recipes by author \"$1\":"

    while read -r line
    do
        echo "Recipe name: $line"
        run_sql_var "SELECT ingredient_name_r, weight_g_r FROM recipes_ingredients WHERE id_recipe_fk=(SELECT id_recipe FROM recipes_list WHERE author='$1' AND recipe_name='$line');" # prints out ingredient and weight
    done <<< "$recipe_names"
}

# first parameter is <date>
function query_shortest {
    # MOJE POZN.: zkontroluj asi date
    date="$1"
    if [ "$DEBUG_ON" = "TRUE" ];
        then
        echo "DEBUGGING: list of recipes ordered in descending order by 'number_of_ingredients' and in ascending order by 'recipe_name':" >&2
        sql_command_tmp="SELECT recipe_name,author,count AS number_of_ingredients FROM recipes_list JOIN
            /*Counting number of ingredients of appropriate dates contained at the same time in fridge and recipe*/
            (SELECT id_recipe_fk, COUNT(*) AS count FROM (
                /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
                SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '$date'
            ) AS T GROUP BY id_recipe_fk) AS T2
        ON (id_recipe=id_recipe_fk) ORDER BY count DESC, recipe_name;"
        run_sql_var "$sql_command_tmp" >&2
    fi

    echo "Recepe which uses the most ingredients in fridge with date <= $date:"
    sql_command="/* Matching together id_recipes_fk with recipe_name and author (JOIN) and selecting first row (LIMIT 1). Order is descending by count and ascending by recipe_name.*/
    SELECT recipe_name,author,count AS number_of_ingredients FROM recipes_list JOIN
        /*Counting number of ingredients of appropriate dates contained at the same time in fridge and recipe*/
        (SELECT id_recipe_fk, COUNT(*) AS count FROM (
            /*Table containing every food with date <= from given and that is contained in some recipe (if in more, there will be column for each)*/
            SELECT * FROM fridge,recipes_ingredients WHERE fridge.ingredient_name=recipes_ingredients.ingredient_name_r AND fridge.use_by_date <= '$date'
        ) AS T GROUP BY id_recipe_fk) AS T2
    ON (id_recipe=id_recipe_fk) ORDER BY count DESC, recipe_name ASC LIMIT 1;"
    run_sql_var "$sql_command" # prints out recipe with most ingredients which are in fridge and which has date <= than $date
}


# first parameter is <recipe>, second is <author>
function query_buy_author {
    recipe_name="$1"
    author="$2"
    if [ "$DEBUG_ON" = "TRUE" ];
        then
        # MOJE POZN.: ještě bych mohl vytisknout fridge, recipes_list, recipes_ingredients...
        echo "Debuging info for recipe \"$recipe_name\" by author \"$author\":" >&2
        sql_debug="
        SET @id_recipe_var := (SELECT id_recipe FROM recipes_list WHERE recipe_name='$recipe_name' AND author='$author');
        SELECT ingredient_name_r AS ingredient_name,weight_g_r AS weight_recipe,total_weight_fridge,weight_g_r-COALESCE(total_weight_fridge,0) AS buy FROM (
            (SELECT *,SUM(weight_g) AS total_weight_fridge FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
             ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
        WHERE id_recipe_fk=@id_recipe_var;"
        run_sql_var "$sql_debug" >&2
    fi
    echo "Ingredients to by for \"$recipe_name\" by author \"$author\":"
    sql_command="
    SET @id_recipe_var := (SELECT id_recipe FROM recipes_list WHERE recipe_name='$recipe_name' AND author='$author');
    SELECT ingredient_name_r AS ingredient_name,weight_g_r-COALESCE(total_weight_fridge,0) AS buy FROM (
        (SELECT *,SUM(weight_g) AS total_weight_fridge FROM fridge GROUP BY ingredient_name) AS T RIGHT JOIN recipes_ingredients
         ON (T.ingredient_name=recipes_ingredients.ingredient_name_r))
    WHERE id_recipe_fk=@id_recipe_var AND weight_g_r-COALESCE(total_weight_fridge,0) > 0;"
    run_sql_var "$sql_command"
}

# first parameter is <recipe>
function query_buy {
    recipe="$1"
    sql_authors="SELECT author FROM recipes_list WHERE recipe_name='$recipe';"
    authors=$( run_sql_var "$sql_authors" ) # every line is name of one author
    authors=$( tail -n +2 <<< "$authors" ) # deleting first line == name of columns
#     echo "AUTHORS:
# $authors" >&2 # debug

    while read -r line
    do
        query_buy_author "$recipe" "$line"
        echo ""
    done <<< "$authors"
}


function query {
    if [ "$1" = "recipes" ];
        then
        query_recipes "$2"
    elif [ "$1" = "shortest" ];
        then
        query_shortest "$2"
    elif [ "$1" = "buy" ];
        then
        if [ -n "$3" ];
            then
            query_buy_author "$2" "$3"
        else
            query_buy "$2"
        fi

    else
        echo "--query can be used only as \"--query recipes <author>\" or \"--query shortest <date>\"or \"--query buy <recipe>\". For more information see help (--help)." >&2
        exit 1 # bad parameters
    fi
}



################################
##############################

# Drop all three tables and recreate them
function empty_database {
    run_sql "empty_database.sql"
    prepare_database
}

# fist parameter <table_name> is either "f" for fridge or "i" for recipes_ingredients or "r" recipes_list or "a" for all or combination of first three for example "ri"
function show_tables {
    var="$1"
    if [ "$var" = "a" ];
        then
        var="fir"
    fi

    sql_show=""
    if [[ "$var" = *"f"* ]]; # if contains "f"
        then
        sql_show="$sql_show
SELECT * FROM fridge;"
    fi

    if [[ "$var" = *"r"* ]]; # if contains "r"
        then
        sql_show="$sql_show
SELECT * FROM recipes_list;"
    fi

    if [[ "$var" = *"i"* ]]; # if contains "a"
        then
        sql_show="$sql_show
SELECT * FROM recipes_ingredients;"
    fi

    if [ -n  "$sql_show" ];
        then
        run_sql_var "$sql_show" -vvv
    fi
}

# Parsing arguments
while [ $# -ge 1 ]
	do
	key="$1"
    # echo "$key" #debug
	case "$key" in
        -h|--help)
	   	;;
        --debug)
            DEBUG_ON="TRUE"
        ;;
		--insert)
            echo "insert..." #debug
            if [ $# -lt 3 ]; # $1 is --insert, and at least two more arguments are required
                then
                echo "--insert option needs two parameters. More can be found in help - use --help option." >&2
            fi
            prepare_database
            insert "$2" "$3"
            exit 0
   		;;
        --query)
            prepare_database
            query "$2" "$3" "$4"  # $4 is there because "--query --buy" can have two parameters <recipe> <author>
            exit 0
   		;;
        --empty_database)
            empty_database
            exit 0
        ;;
        --show)
            show_tables "$2"
            exit 0
        ;;
		-v|--variant) # Variant of semestral work of OSD, FEE CTU, summer 2015
			echo "2"
			exit 0
		;;
    	*)
			# is the parameter existing directory
			echo "Invalid parameter \"$key\"." >&2
			exit 1
		;;
	esac
	shift
done


# mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD"< test.sql
echo "DONE"
