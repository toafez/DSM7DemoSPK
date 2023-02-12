#!/bin/bash
# Filename: SPK_Pack_Stage.sh - coded in utf-8

#                DSM7DemoSPK
#
#        Copyright (C) 2023 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# -------------------------------------------------------------------------------------------------
# Please make your desired changes here
# -------------------------------------------------------------------------------------------------

# Define package name and version
package_name="DSM7DemoSPK"
version="1.0-500"


# -------------------------------------------------------------------------------------------------
# Please do not make any changes below, unless you know what you are doing!
# -------------------------------------------------------------------------------------------------


# Create working directory
# -----------------------------------------------
path=$(pwd)
working_dir=/tmp/_${package_name}
if [ -d ${working_dir} ]; then
    rm -rf ${working_dir}
else
    mkdir -p ${working_dir}
fi


# Create pack stage
# -----------------------------------------------
package_dir=${working_dir}/package
mkdir -p ${package_dir}
cp -a ui ${package_dir}


# Create binary file(s)
# -----------------------------------------------
binary_dir=${package_dir}/usr/local/bin
mkdir -p ${binary_dir}
touch ${binary_dir}/${package_name}
echo "#!/bin/sh" >> ${binary_dir}/${package_name}
echo '/var/packages/'${package_name}'/scripts/start-stop-status "$@"' >> ${binary_dir}/${package_name}


# Create SPK
# -----------------------------------------------
cp -a conf ${working_dir}/conf
cp -a scripts ${working_dir}/scripts
cp -a WIZARD_UIFILES ${working_dir}/WIZARD_UIFILES
cp -a CHANGELOG ${working_dir}
cp -a LICENSE ${working_dir}
cp -a PACKAGE_ICON*.PNG ${working_dir}

sed '1d' INFO.sh > ${working_dir}/INFO.tmp
head -n -2 < ${working_dir}/INFO.tmp > ${working_dir}/INFO
rm ${working_dir}/INFO.tmp

chmod -R 777 ${working_dir}
chmod -R 755 ${package_dir}


# Build SPK
# -----------------------------------------------
tar -C ${package_dir}/ -czf ${working_dir}/package.tgz .
chmod 755 ${working_dir}/package.tgz
rm -rf ${package_dir}
cd ${working_dir}
tar --exclude=".git/*" --exclude=".gitignore/*" -cvf ${working_dir}/${package_name}-${version}.spk *
mv ${working_dir}/${package_name}-${version}.spk ${path}
rm -rf ${working_dir}

