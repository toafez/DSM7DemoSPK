#!/bin/bash
# Filename: SPK_Build_Stage.sh - coded in utf-8

#                DSM7DemoSPK
#
#        Copyright (C) 2023 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# -------------------------------------------------------------------------------------------------
# Please make your desired changes here
# -------------------------------------------------------------------------------------------------


# Changing the package name
packagename="DSM7DemoSPK"

# Changing the copyright
copyright="Copyright (C) 2023 by"

# Changing the maintrainer name
maintrainer="Tommes"

# Change the name of the package directory to [packagename]? yes/no
changedirname="no" 


# -------------------------------------------------------------------------------------------------
# Please do not make any changes below, unless you know what you are doing!
# -------------------------------------------------------------------------------------------------
old_packagename="DSM7DemoSPK"
old_copyright="Copyright (C) 2023 by"
old_maintrainer="Tommes"
path=$(pwd)


# Change file names that contain the package name
# -----------------------------------------------
if [[ "${old_packagename}" != "${packagename}" ]]; then
    mv ./${old_packagename}.c ./${packagename}.c
    mv ./ui/${old_packagename}.js ./ui/${packagename}.js
    chmod 777 ./${packagename}.c
    chmod 777 ./ui/${packagename}.js
    echo 'File names containing the name [ '${old_packagename}' ] were renamed to [ '${packagename}' ]'
else
    echo 'No file names have been changed'
fi


# Customize Package Name
# -----------------------------------------------
if [[ "${packagename}" != "${old_packagename}" ]]; then
    find . -type f -print0 | xargs -0 -n 1 sed -i -e 's/'"${old_packagename}"'/'"${packagename}"'/g'
    echo 'Package name was changed from [ '${old_packagename}' ] to [ '${packagename}' ]'
else
    echo 'The Package name [ '${packagename}' ] was not changed'
fi


# Costumize Maintrainer
# -----------------------------------------------
if [[ "${maintrainer}" != "${old_maintrainer}" ]]; then
    find . -type f -print0 | xargs -0 -n 1 sed -i -e 's/'"${old_maintrainer}"'/'"${maintrainer}"'/g'
    echo 'Maintrainer was changed from [ '${old_maintrainer}' ] to [ '${maintrainer}' ]'
else
    echo 'Maintrainer [ '${maintrainer}' ] was not changed'
fi


# Costumize Copyright
# -----------------------------------------------
if [[ "${copyright}" != "${old_copyright}" ]]; then
    find . -type f -print0 | xargs -0 -n 1 sed -i -e 's/'"${old_copyright}"'/'"${copyright}"'/g'
    echo 'Copyright was changed from [ '${old_copyright}' ] to [ '${copyright}' ]'
else
    echo 'Copyright [ '${copyright}' ] was not changed'
fi

if [[ "${changedirname}" == "yes" ]]; then
    mv ${path} ${path%/*}/${packagename}
    cd ${path%/*}/${packagename}
    exec bash
else
    exit 0
fi

