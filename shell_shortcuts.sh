# Includes shell profile shortcuts and aliases that I have found
# to be useful when programming. 

# NOTE: this file is non-executable. I have included these in my .zshrc file.

# Makes the specified file executable.
# usage: chx <file>
alias chx="chmod 755 "

# Creates a new directory and moves into it
# usage: mkcd <folder>
mkcd() { mkdir -p "$1"; cd "$1" }

# Move into a folder and list its files
# usage: cdl <folder>
cdl() { cd "$1"; ls -l }

# Find locaion of a file in the current folder
# usage: ffile <file> 
alias ffile="find . -name "