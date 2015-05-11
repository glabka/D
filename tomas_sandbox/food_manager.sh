#!/bin/bash
# parsování vstupů
# Pokud nebudou exitavat příslušné základní tabulky (tj. obsah_ledničky a recepty), tak je vytvoříme

database=d_test

# Add tables requared for proper funcioning of functions insert and query
function prepare_database {
    mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD"< prepare_database.sql
    ret_val="$?"
    # MOJE POZN.: udělej něco podle návratové hodnoty...
}

# function insert {
#
# }
#
# function query {
#
# }


# Parsing arguments
while [ $# -ge 1 ]
	do
	key="$1"
    # echo "$key" #debug
	case "$key" in
	   -h|--help)
	   	;;
		--insert)
        echo "insert..." #debug
            if [ $# -lt 3 ]; # $1 is --insert, and at least two more arguments are required
                then
                echo "--insert option needs two parameters. More can be found in help - use --help option." >&2
            fi
            prepare_database
            exit 0;
            insert "$1" "$2"
   		;;
        --query)
            prepare_database
   		;;
		-v) # Version of task of imlementation of semestral work of OSD, FEE CTU
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
