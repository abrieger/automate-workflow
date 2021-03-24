#!/bin/dash

# Program changes extensions of files
# Written by Adam Brieger on 24 March 2021

if test $# -eq 0
then
    echo "usage: ./change_ext.sh <projectdir>" >&2
    exit 1
fi

read -p "Enter the old extension: " old_ext
read -p "Enter the new extension: " new_ext

for file in *
do
    test "$file" = "change_ext.sh" &&
        continue # Ignore this script
    if test -d "$file" 
    then
        # If file is directory, run script inside directory
        "$0" "$file"/*
    else
        echo "$file" | 
        grep -E "${old_ext}$" | # Retrieve only files ending with ext
        while read res
        do
            no_ext=$(echo $res | sed -E 's/\..*$//') # Delete old extension
            new_filename=${no_ext}${new_ext} # Add new extension

            if test -e "$new_filename"
            then
                echo "$new_filename already exists" >&2
                continue
            fi

            echo "$file -> $new_filename"
            mv -- "$file" "$new_filename" # Replace old file
        done

    fi
done