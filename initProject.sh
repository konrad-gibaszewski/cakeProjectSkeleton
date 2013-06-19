#!/bin/bash

# Simple bash script to copy default file into it's target positions.

# Files to be copied from defaults
#
# app/.htaccess.default
# app/Config/core.default.php
# app/Config/database.default.php
# app/Config/email.default.php
# app/webroot/.htaccess
# app/webroot/robots.txt
# app/webroot/repoData/config/config.ini


# copyFile sourceFileName destinationFileName
#
# Copies source file into it's destination and asks if you want to edit it with nano
#
function copyFile {

    cp -pvi $1 $2
    read -p "Would you like to edit $2 (y/n [n])? "
    ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && nano $2

}

# showMessage
#
# show message to the user. Accepts up to three parameters:
# - first - title, comes in bold magenta, 
# - second - message, comes in standard text color,
# - third - status, comes in bold green.
#
function showMessage {

    echo -e "\n\033[1;36m $1\033[0m $2\033[1;32m $3\033[0m";

}


# Init git submodules
showMessage "Git submodules" "intialising..."
git submodule init
git submodule update
showMessage "Git submodules" "intialising..." "OK"

# Init app (copy defaults to its target positions)
showMessage "Application config files" "intialising..."
cd app/
copyFile .htaccess.default .htaccess
cd Config/
copyFile core.default.php core.php
copyFile database.default.php database.php
copyFile email.default.php email.php
cd ../webroot/
copyFile .htaccess.default .htaccess
copyFile robots.default.txt robots.txt
showMessage "Application config files" "intialising..." "OK"

# Init git auto pull
showMessage "Git auto pull config file" "intialising..."
cd repoData/config/
copyFile config.ini.default config.ini
showMessage "Git auto pull config file" "intialising..." "OK"

# Exit msg
showMessage "Success" "Project initialisation finished."
echo -e "\033[1;35m Edit\033[0m You should edit files specified below:\n
         > app/.htaccess.default\r
         > app/Config/core.default.php\r
         > app/Config/database.default.php\r
         > app/Config/email.default.php\r
         > app/webroot/.htaccess\r
         > app/webroot/robots.txt\r
         > app/webroot/repoData/config/config.ini\n";
