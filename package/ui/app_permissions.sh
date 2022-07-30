#!/bin/sh
# Filename: app_permissions.sh - coded in utf-8

#                DSM7DemoSPK
#
#        Copyright (C) 2022 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# call: /usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh
app_name="DSM7DemoSPK"


# Function: Add or remove users from a group
# --------------------------------------------------------------
# Call: synogroupuser "[adduser or deluser]" "GROUP" "USER"
function synogroupuser()
{
	oldIFS=${IFS}
	IFS=$'\n'
	query=${1}
	group=${2}
	user=${3}
	userlist=$(synogroup --get ${group} | grep -E '^[0-9]*:'| sed -e 's/^[0-9]*:\[\(.*\)\]/\1/')
	updatelist=()
	for i in ${userlist}; do
		if [[ "${query}" == "adduser" ]]; then
			[[ "${i}" != "${user}" ]] && updatelist+=(${i})
			[[ "${i}" == "${user}" ]] && userexists="true"
		elif [[ "${query}" == "deluser" ]]; then
			[[ "${i}" != "${user}" ]] && updatelist+=(${i})
			[[ "${i}" == "${user}" ]] && userexists="true"
		else
			synodsmnotify -c SYNO.SDS._ThirdParty.App.${app_name} @administrators ${app_name}:app:title ${app_name}:app:groupuser_error
			exit 1
		fi
	done

	if [[ -z "${userexists}" && "${query}" == "adduser" ]]; then
		updatelist+=(${user})
		synogroup --member ${group} ${updatelist[@]}
		synodsmnotify -c SYNO.SDS._ThirdParty.App.${app_name} @administrators ${app_name}:app:title ${app_name}:app:adduser_true
	elif [[ -n "${userexists}" && "${query}" == "adduser" ]]; then
		synodsmnotify -c SYNO.SDS._ThirdParty.App.${app_name} @administrators ${app_name}:app:title ${app_name}:app:adduser_exists
		exit 2
	elif [[ -n "${userexists}" && "${query}" == "deluser" ]]; then
		synogroup --member ${group} ${updatelist[@]}
		synodsmnotify -c SYNO.SDS._ThirdParty.App.${app_name} @administrators ${app_name}:app:title ${app_name}:app:deluser_true
	elif [[ -z "${userexists}" && "${query}" == "deluser" ]]; then
		synodsmnotify -c SYNO.SDS._ThirdParty.App.${app_name} @administrators ${app_name}:app:title ${app_name}:app:deluser_notexist
		exit 3
	fi

	IFS=${oldIFS}
}

# Set App permissions
# --------------------------------------------------------------

	# Check if version corresponds to min. DSM 7
	# ----------------------------------------------------------
	if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then

		# Add DSM7DemoSPK to the administrators group
		if [[ "${1}" == "adduser" ]]; then
			synogroupuser "adduser" "administrators" "DSM7DemoSPK"
		fi

		# Remove DSM7DemoSPK from administrators group
		if [[ "${1}" == "deluser" ]]; then
			synogroupuser "deluser" "administrators" "DSM7DemoSPK"
		fi

	fi
