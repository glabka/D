#!/bin/bash

echo "$@"  # all parameters
echo "${*:2}" # all parameters but first
echo "$1" # first parameter
echo "......................."

#
# var="$1"
# if [ "$var" = "a" ];
#     then
#     var="fir"
# fi
#
# if [[ "$var" = *"f"* ]]; # if contains "f"
#     then
#     echo f
# fi
# if [[ "$var" = *"i"* ]]; # if contains "a"
#     then
#     echo i
# fi
# if [[ "$var" = *"r"* ]]; # if contains "r"
#     then
#     echo r
# fi
#
# sql_show="";
# if [[ "$var" = *"f"* ]]; # if contains "f"
#     then
#     sql_show="SELECT * FROM fridge;"
# fi
#
# if [[ "$var" = *"r"* ]]; # if contains "r"
#     then
#     sql_show="$sql_show
# SELECT * FROM recipes_list;"
# fi
#
# if [[ "$var" = *"i"* ]]; # if contains "a"
#     then
#     sql_show="$sql_show
# SELECT * FROM recipes_ingredients;"
# fi
#
#
# if [ -n "$recipes_list"];
#     then
#     echo "$sql_show"
# else
#     echo "No command"
# fi
#
#
#
#
#
#
# function show_tables {
#     var="$1"
#     if [ "$var" = "a" ];
#         then
#         var="fir"
#     fi
#
#     sql_show=""
#     if [[ "$var" = *"f"* ]]; # if contains "f"
#         then
#         sql_show="$sql_show
# SELECT * FROM fridge;"
#     fi
#
#     if [[ "$var" = *"r"* ]]; # if contains "r"
#         then
#         sql_show="$sql_show
# SELECT * FROM recipes_list;"
#     fi
#
#     if [[ "$var" = *"i"* ]]; # if contains "a"
#         then
#         sql_show="$sql_show
# SELECT * FROM recipes_ingredients;"
#     fi
#
#     if  [ "$DEBUG_ON" = "TRUE" ];
#         then
#         if [ -n "$sql_show" ];
#             then
#             echo "Debug: --show: generated commands:"
#             echo "$sql_show" >&2
#         else
#             echo "DEBUG: --show -> no command" >&2
#         fi
#     fi
#
#     if [ -n "$sql_show" ];
#         then
#         run_sql_var "$sql_show"
#     fi
# }
