#!/bin/dash

# Program outputs location TODO and FIXME statements in project
# Written by Adam Brieger on 24 March 2021

if test $# -eq 0
then
    echo "usage: ./find_TODO_FIXME.sh <projectdir>"
    exit 1
fi

for file in "$@"
do
    test "$file" = "find_TODO_FIXME.sh" &&
        continue # Ignore this script
    if test -d "$file" 
    then
        # If file is directory, run script inside directory
        "$0" "$file"/*
    else
        test -f "$file" && # Do not grep empty directories
        found=$(grep -Eno 'TODO|FIXME' "$file")
        if test ! -z "$found"
        then
            # Located TODO or FIXME in this file
            tmp=$(mktemp)
            trap 'rm -f $tmp' INT TERM EXIT
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
