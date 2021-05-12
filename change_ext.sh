#!/bin/dash

# Program changes extensions of files in current directory
# Written by Adam Brieger

if test $# -ne 0
then
    echo "usage: ./change_ext.sh" >&2
    exit 1
fi

read -p "Enter the old extension (excluding dot): " old_ext
read -p "Enter the new extension (excluding dot): " new_ext

for file in $(find * -type f)
do
    test "$file" = "change_ext.sh" &&
        continue # Ignore this script

    echo "$file" | 
    grep -E "${old_ext}$" | # Retrieve only files ending with ext
    while read res
    do
        no_ext=$(echo $res | sed -E 's/\..*$/\./') # Delete old extension
        new_filename=${no_ext}${new_ext} # Add new extension

        if test -e "$new_filename"
        then
            # Do not overwrite existing files
            echo "$new_filename already exists" >&2
            continue
        fi

        echo "$file -> $new_filename"
        mv -- "$file" "$new_filename" # Replace old file
    done

done