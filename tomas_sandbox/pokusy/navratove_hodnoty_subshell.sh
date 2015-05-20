
function funkce {
    exit 33
}

# pripad 1 => return == 33
# funkce
# exit 0

# pripad 2 => return == 0
# var=$( funkce )
# exit 0

# pripad 3
var=$( funkce )
ret_val="$?"
echo "$ret_val"
exit "$ret_val"
