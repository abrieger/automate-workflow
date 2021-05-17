#!/bin/dash
# NOTE these sed commands are compatible with Linux only

# Program creates skeleton of Java file
# Written by Adam Brieger

echo -n "Enter your name: "
read name
echo -n "Enter the class name: "
read class

# Ensure class is camel case with first letter capitalised
class=$(echo $class | sed -E 's/^(.)/\u\1/; s/ (.)/ \u\1/g' | tr -dc '[[:alpha:]]')

created=$(date +"%d/%m/%Y")

if [ -e "${class}.java" ]
then
    echo "File name already exists!" >&2
    exit 1
fi

cat > "${class}.java" <<EOF
// Program written by $name on $created

public $class {

    static public void main(String[] args) {


    }
}
EOF