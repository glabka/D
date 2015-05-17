#!/bin/bash
# parsování vstupů
# Pokud nebudou exitavat příslušné základní tabulky (tj. obsah_ledničky a recepty), tak je vytvoříme

DEBUG_ON="FALSE"

function run_sql_var {
    # echo "run_sql_var" # debug
    mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" <<< "$1"
    echo "DONE" >&2 # debug
}

function run_sql {
    # echo "run_sql" # debug
    mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" < "$1"
    echo "DONE" >&2 # debug
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
        sql_insert_recipe "$tmp" >> "$sql_insert_file"

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
    sql_authors="SELECT recipe_name FROM recipes_list WHERE author='$1';"
    recipe_names=$( run_sql_var "$sql_authors" ) # every line is name of one recipe
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

# # first parameter is <recipe>
# function query_buy {
#
# }

function query {
    if [ "$1" = "recipes" ];
        then
        query_recipes "$2"
    elif [ "$1" = "shortest" ];
        then
        query_shortest "$2"
    elif [ "$1" = "buy" ];
        then
        query_buy "$2"
    else
        echo "--query can be used only as \"--query recipes <author>\" or \"--query shortest <date>\"or \"--query buy <recipe>\". For more information see help (--help)."
        exit 1 # bad parameters
    fi
}



################################
##############################

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
            query "$2" "$3"
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
