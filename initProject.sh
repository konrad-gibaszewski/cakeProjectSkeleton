#!/bin/bash

# Simple bash script to copy default file into it's target positions.
#
# @toDo Completion statuses come on the end of the lines
# @toDo Git messages are shown only on error
# @toDo Confirmation for copy action of each files
# @toDo Done. Overwrite check for files
# @toDo Propose direct edit action for each file copied (answer with y/N)


# Files to be copied from defaults
#
# app/.htaccess.default
# app/Config/core.default.php
# app/Config/database.default.php
# app/Config/email.default.php
# app/webroot/.htaccess
# app/webroot/robots.txt
# app/webroot/repoData/config/config.ini

# Init git submodules
echo -e "\n\033[1;36m Git submodules\033[0m intialising...";
git submodule init
git submodule update
echo -e "\n\033[1;36m Git submodules\033[0m intialising...\033[1;32m OK\033[0m";


# Init app (copy defaults to its target positions)
echo -e "\n\033[1;36m Application config files\033[0m intialising...";
cd app/
cp -pvi .htaccess.default .htaccess
cd Config/
cp -pvi core.default.php core.php
cp -pvi database.default.php database.php
cp -pvi email.default.php email.php
cd ../webroot/
cp -pvi .htaccess.default .htaccess
cp -pvi robots.default.txt robots.txt
echo -e "\n\033[1;36m Application config files\033[0m intialising...\033[1;32m OK\033[0m";

# Init git auto pull
echo -e "\n\033[1;36m Git auto pull config file\033[0m intialising...";
cd repoData/config/
cp -pvi config.ini.default config.ini
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
