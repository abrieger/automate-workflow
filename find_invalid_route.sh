#!/bin/dash

# Program outputs location of clear/v2 route in specified directory
# Written by Adam Brieger on 13 April 2021

if test $# -eq 0
then
    echo "usage: ./find_invalid_route.sh <projectdir>" >&2
    exit 1
fi

for file in "$@"
do
    test "$file" = "find_invalid_route.sh" &&
        continue # Ignore this script
    if $(echo "$file" | grep '__pycache__'>/dev/null)
    then
        continue # Ignore pycache
    fi 

    if test -d "$file" 
    then
        # If file is directory, run script inside directory
        "$0" "$file"/*
    else
        test -f "$file" && # Do not grep empty directories
        found=$(grep -Eno 'clear/v2' "$file") # Change search here for other funcs or routes
        if test ! -z "$found"
        then
            # Located route in this file
            tmp=$(mktemp)
            trap 'rm -f $tmp; exit' INT TERM EXIT
            echo "$found" > "$tmp"

            echo "-------------------------------------------------------------"
            echo "\t File: $file"
            echo "-------------------------------------------------------------"

            while read line 
            do
                # Extract and reformat grep results
                line_num=$(echo $line | cut -d':' -f1)
                no_context=$(echo $line | cut -d':' -f2)
                echo "Found $no_context on line $line_num"
            done <"$tmp"

            rm -f "$tmp" # Remove temporary file and reset trap
            trap - INT TERM EXIT
        fi
    fi
done
