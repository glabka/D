# first parameter is <recipe,author_first_name,author_last_name>
function query_buy {
    echo "\$1 == $1"
    tmp=$( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/[ \t]*,[ \t]*/,/g' <<< "$1" ) #deleting spaces
    tmp=$( tr ',' '\n' <<< "$tmp" ) # spliting to lines values separated by commas
    count_lines=$( wc -l <<< "$tmp" )
    # echo "\$count_lines == $count_lines"
    # echo "\$tmp = $tmp"

    if [ "$count_lines" -eq 1 ];
        then
        # entered only recipe
        echo "entered only recipe" >&2 # debug
        recipe="$tmp"
        sql_authors="SELECT author_first_name,author_last_name FROM recipes_list WHERE recipe_name='$recipe';"
        authors=$( run_sql_var "$sql_authors" -ss ) # ss == without head with column names
        echo "\$authors == $authors" # debug
        while read -r line
        do
            echo "\$line == $line"
            first_and_last_name=$( sed -r -e 's/[ \t]+/\n/g' <<< "$line" ) # substitude tab and spaces for '\n'
            read -r first_name <<< "$first_and_last_names"
            last_name=$( tail -n +2 <<< "$first_and_last_name" )
            echo "\$first_name == $first_name" # debug
            echo "\$last_name == $last_name" # debug


            # TODO (Tady to nejak nefunguje - nad tím)
            query_buy_author "$recipe" "$line"
            echo ""
        done <<< "$authors"
    elif [ "$count_lines" -eq 2 ];
        then
        # recipe and author_first_name entered
        echo "recipe and author_first_name entered" >&2 # debug
    elif [ "$count_lines" -eq 3 ];
        then
        # recipe, author_first_name and author_last_name entered
        echo "recipe, author_first_name and author_last_name entered" >&2 # debug
    else
        echo "Invalid number of values separated by comma in --query buy <recipe[,author_first_name][,author_last_name]>" >&2
    fi


    # old
    read -r recipe <<< "$tmp"
    tmp=$( tail -n +2 <<< "$tmp" ) # deleting first line (already read). -n +2 == start form second line
    read -r first_name <<< "$tmp"
    tmp=$( tail -n +2 <<< "$tmp" ) # deleting first line (already read). -n +2 == start form second line
    read -r last_name <<< "$tmp"
    tmp=$( tail -n +2 <<< "$tmp" ) # deleting first line (already read). -n +2 == start form second line

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
