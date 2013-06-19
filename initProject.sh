#!/bin/bash

# Simple bash script to copy default file into it's target positions.
#
# Licensed under The MIT License
# Redistributions of files must retain the above copyright notice.
#
# @toDo         https://github.com/syncube/cakeProjectSkeleton/issues
# @copyright    Copyright (c) 2013, Konrad Gibaszewski
# @license      http://www.opensource.org/licenses/mit-license.php The MIT License

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
    read -p "Would you like to edit $2 (y/n [n])?"
    ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && nano $2

}


# Init git submodules
echo -e "\n\033[1;36m Git submodules\033[0m intialising...";
git submodule init
git submodule update
echo -e "\n\033[1;36m Git submodules\033[0m intialising...\033[1;32m OK\033[0m";


# Init app (copy defaults to its target positions)
echo -e "\n\033[1;36m Application config files\033[0m intialising...";
cd app/
copyFile .htaccess.default .htaccess
cd Config/
copyFile core.default.php core.php
copyFile database.default.php database.php
copyFile email.default.php email.php
cd ../webroot/
copyFile .htaccess.default .htaccess
copyFile robots.default.txt robots.txt
echo -e "\n\033[1;36m Application config files\033[0m intialising...\033[1;32m OK\033[0m";

# Init git auto pull
echo -e "\n\033[1;36m Git auto pull config file\033[0m intialising...";
cd repoData/config/
copyFile config.ini.default config.ini
echo -e "\n\033[1;36m Git auto pull config file\033[0m intialising...\033[1;32m OK\033[0m";

# Exit msg
echo -e "\n\033[1;32m Success\033[0m Project initialisation finished."
echo -e "\033[1;35m Edit\033[0m You should edit files specified below:\n
         > app/.htaccess.default\r
         > app/Config/core.default.php\r
         > app/Config/database.default.php\r
         > app/Config/email.default.php\r
         > app/webroot/.htaccess\r
         > app/webroot/robots.txt\r
         > app/webroot/repoData/config/config.ini\n";
