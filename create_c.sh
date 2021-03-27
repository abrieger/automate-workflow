#!/bin/dash

# Program creates skeleton of C file
# Written by Adam Brieger on 24 March 2021

echo -n "Enter your name: "
read name
echo -n "Enter the filename: "
read filename

created=$(date +"%d/%m/%Y")

if [ -e "${filename}.c" ]
then
    echo "File name already exists!" >&2
    exit 1
fi

cat > "${filename}.c" <<EOF
// Program written by $name on $created
 
#include <stdio.h>
#include <stdlib.h>

int main(void) {

    return 0;
}
EOF