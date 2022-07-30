#!/bin/bash
# Filename: build_spk.sh - coded in utf-8

#                DSM7DemoSPK
#
#        Copyright (C) 2022 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# Change the package name (if desired)
original_name="DSM7DemoSPK"
new_name="DSM7DemoSPK"

# Set folder and file permissions
chmod -R 755 ./package
chmod 700 ./package/ui/modules/synowebapi
chmod -R 777 ./conf
chmod -R 777 ./scripts
chmod -R 777 ./WIZARD_UIFILES
chmod 777 ./CHANGELOG
chmod 777 ./INFO
chmod 777 ./LICENSE
chmod 777 ./PACKAGE_ICON*

# Customize the package name
[[ "${original_name}" != "${new_name}" ]] && mv ./package/bin/${original_name}-cli ./package/bin/${new_name}-cli
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/bin/${new_name}-cli
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/ui/lang/*.txt
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/ui/app_permissions.sh
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/ui/config
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/ui/index.cgi
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./package/ui/main.sh
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./conf/*
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./WIZARD_UIFILES/*
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./CHANGELOG
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./INFO
sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./LICENSE

# If a new name has been given to the SPK, change the original name
[[ "${original_name}" != "${new_name}" ]] && sed -i 's/'"${original_name}"'/'"${new_name}"'/g' ./build_spk.sh

# Build SPK
tar -C ./package/ -czf ./package.tgz .
chmod 755 ./package.tgz
tar --exclude="package/*" --exclude="build_spk.sh" --exclude=".git/*" --exclude=".gitignore/*" --exclude="README.md" --exclude="README_en.md" -cvf ${new_name}.spk *
rm -f package.tgz