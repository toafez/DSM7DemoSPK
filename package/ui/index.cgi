#!/bin/bash
# Filename: index.cgi - coded in utf-8

#                DSM7DemoSPK
#
#        Copyright (C) 2022 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# Initiate system
# --------------------------------------------------------------
	PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/syno/bin:/usr/syno/sbin

	app_name="DSM7DemoSPK"
	display_name="SPK Development for DSM 7"
	app_home=$(echo /volume*/@appstore/${app_name}/ui)
	app_link=$(echo /webman/3rdparty/${app_name})
	[ ! -d "${app_home}" ] && exit

	# Resetting access permissions
	unset syno_login rar_data syno_privilege syno_token syno_user user_exist is_admin is_authenticated


# Evaluate app authentication
# --------------------------------------------------------------
	# To evaluate the SynoToken, change REQUEST_METHOD to GET
	[[ "${REQUEST_METHOD}" == "POST" ]] && REQUEST_METHOD="GET" && OLD_REQUEST_METHOD="POST"


		# Read out and check the login authorization  ( login.cgi )
		# ----------------------------------------------------------
		syno_login=$(/usr/syno/synoman/webman/login.cgi)

		# SynoToken ( only when protection against Cross-Site Request Forgery Attacks is enabled )
		if echo ${syno_login} | grep -q SynoToken ; then
			syno_token=$(echo "${syno_login}" | grep SynoToken | cut -d ":" -f2 | cut -d '"' -f2)
		fi
		if [ -n "${syno_token}" ]; then
			[ -z ${QUERY_STRING} ] && QUERY_STRING="SynoToken=${syno_token}" || QUERY_STRING="${QUERY_STRING}&SynoToken=${syno_token}"
		fi

		# Login permission ( result=success )
		if echo ${syno_login} | grep -q result ; then
			login_result=$(echo "${syno_login}" | grep result | cut -d ":" -f2 | cut -d '"' -f2)
		fi
		[[ ${login_result} != "success" ]] && { echo 'Access denied'; exit; }

		# Login successful ( success=true )
		if echo ${syno_login} | grep -q success ; then
			login_success=$(echo "${syno_login}" | grep success | cut -d "," -f3 | grep success | cut -d ":" -f2 | cut -d " " -f2 )
		fi
		[[ ${login_success} != "true" ]] && { echo 'Access denied'; exit; }


	# Set REQUEST_METHOD back to POST again
	[[ "${OLD_REQUEST_METHOD}" == "POST" ]] && REQUEST_METHOD="POST" && unset OLD_REQUEST_METHOD


	# Reading user/group from authenticate.cgi
	# ----------------------------------------------------------
		syno_user=$(/usr/syno/synoman/webman/authenticate.cgi)

		# Check if the user exists
		user_exist=$(grep -o "^${syno_user}:" /etc/passwd)
		[ -n "${user_exist}" ] && user_exist="yes" || exit

		# Check whether the local user belongs to the "administrators" group
		if id -G "${syno_user}" | grep -q 101; then
			is_admin="yes"
		else
			is_admin="no"
		fi


	# Evaluate app level authentication
	# ----------------------------------------------------------
		# To evaluate the authentication, the file /usr/syno/bin/synowebapi 
		# must be copied to ${app_home}/modules/synowebapi, and the ownership 
		# must be adjusted to ${app_name}:${app_name}

		if [ -f "${app_home}/modules/synowebapi" ]; then
			rar_data=$($app_home/modules/synowebapi --exec api=SYNO.Core.Desktop.Initdata method=get version=1 runner="$syno_user" | jq '.data.AppPrivilege')
			syno_privilege=$(echo "${rar_data}" | grep "SYNO.SDS._ThirdParty.App.${app_name}" | cut -d ":" -f2 | cut -d '"' -f2)
			if echo "${syno_privilege}" | grep -q "true"; then
				is_authenticated="yes"
			else
				is_authenticated="no"
			fi
		else
			is_authenticated="no"
			txtActivatePrivileg="<strong>To enable app level authentication do...</strong><br /><strong>root@[local-machine]:~#</strong> cp /usr/syno/bin/synowebapi /var/packages/${app_name}/target/ui/modules<br /><strong>root@[local-machine]:~#</strong> chown ${app_name}.${app_name} /var/packages/${app_name}/target/ui/modules/synowebapi"
		fi


	# Set variables to "readonly" for protection or empty contents
	# ----------------------------------------------------------
		unset syno_login rar_data syno_privilege
		readonly syno_token syno_user user_exist is_admin is_authenticated


# Set environment variables
# --------------------------------------------------------------
	# Set up folder for temporary data
	app_temp="${app_home}/temp"
	[ ! -d "${app_temp}" ] && mkdir -p -m 755 "${app_temp}"
	result="${app_temp}/result.txt"

	# Set up folder for user data
	usr_settings="${app_home}/usersettings"
	[ ! -d "${usr_settings}" ] && mkdir -p -m 755 "${usr_settings}"

	# Evaluate POST and GET requests and cache them in files
	set_keyvalue="/usr/syno/bin/synosetkeyvalue"
	get_keyvalue="/bin/get_key_value"
	get_request="$app_temp/get_request.txt"
	post_request="$app_temp/post_request.txt"

	# If no page set, then show home page
	if [ -z "${get[page]}" ]; then
		"${set_keyvalue}" "${get_request}" "get[page]" "main"
		"${set_keyvalue}" "${get_request}" "get[section]" "start"
		"${set_keyvalue}" "${get_request}" "get[SynoToken]" "$syno_token"
	fi


# Processing GET/POST request variables
# --------------------------------------------------------------
	# Load urlencode and urldecode function from ../modules/parse_url.sh
	[ -f "${app_home}/modules/parse_url.sh" ] && source "${app_home}/modules/parse_url.sh" || exit

	[ -z "${POST_STRING}" -a "${REQUEST_METHOD}" = "POST" -a ! -z "${CONTENT_LENGTH}" ] && read -n ${CONTENT_LENGTH} POST_STRING

	# Securing the Internal Field Separator (IFS) as well as the separation
	# of the GET/POST key/value requests, by locating the separator "&"
	if [ -z "${backupIFS}" ]; then
		backupIFS="${IFS}"
		IFS='=&'
		GET_vars=(${QUERY_STRING})
		POST_vars=(${POST_STRING})
		readonly backupIFS
		IFS="${backupIFS}"
	fi

	# Analyze incoming GET requests and process them to ${get[key]}="$value" variables
	declare -A get
	for ((i=0; i<${#GET_vars[@]}; i+=2)); do
		GET_key=get[${GET_vars[i]}]
		GET_value=${GET_vars[i+1]}
		#GET_value=$(urldecode ${GET_vars[i+1]})

		# Reset saved GET/POST requests if main is set
		if [[ "${get[page]}" == "main" ]] && [ -z "${get[section]}" ]; then
			[ -f "${get_request}" ] && rm "${get_request}"
			[ -f "${post_request}" ] && rm "${post_request}"
		fi

		# Saving GET requests for later processing
		"${set_keyvalue}" "${get_request}" "$GET_key" "$GET_value"
	done
		# Adding the SynoToken to the GET request processing
		"${set_keyvalue}" "${get_request}" "get[SynoToken]" "$syno_token"

	# Analyze incoming POST requests and process to ${var[key]}="$value" variables
	declare -A post
	for ((i=0; i<${#POST_vars[@]}; i+=2)); do
		POST_key=post[${POST_vars[i]}]
		#POST_value=${POST_vars[i+1]}
		POST_value=$(urldecode ${POST_vars[i+1]})

		# Saving POST requests for later processing
		"${set_keyvalue}" "${post_request}" "$POST_key" "$POST_value"
	done

	# Inclusion of the temporarily stored GET/POST requests ( key="value" ) as well as the user settings
	[ -f "${get_request}" ] && source "${get_request}"
	[ -f "${post_request}" ] && source "${post_request}"

# Layout output
# --------------------------------------------------------------
if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then

	# Load language settings from ../modules/parse_language.sh
	[ -f "${app_home}/modules/parse_language.sh" ] && source "${app_home}/modules/parse_language.sh" || exit

	echo "Content-type: text/html"
	echo
	echo '
	<!doctype html>
	<html lang="en">
		<head>
			<meta charset="utf-8" />
			<title>'${display_name}'</title>
			<link rel="shortcut icon" href="images/icon_32.png" type="image/x-icon" />
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
		</head>
		<body>
			<header></header>
			<article>'

				# Function: Include header
				# --------------------------------------------------------------
				function header()
				{
					echo '<h2>'${txtAppTitle}'</h2>'
				}

				# Load page content
				# --------------------------------------------------------------
				if [[ "${is_admin}" == "yes" ]]; then

					# Infotext: Enable application level authentication
					[ -n "${txtActivatePrivileg}" ] && echo ''${txtActivatePrivileg}''

					# Dynamic page output
					if [ -f "${get[page]}.sh" ]; then
						. ./"${get[page]}.sh"
					else
						echo 'Page '${get[page]}'.sh not found!'
					fi

					# Debug
					# ----------------------------------------------------------
					# HTTP GET and POST requests
					echo '
					<br \>
					<strong>GET requests</strong>
					<pre>'; cat ${get_request}; echo '</pre>
					<strong>POST requests</strong>
					<pre>'; cat ${post_request}; echo '</pre>
					<br />'

					# Local environment		
					echo '
					<strong>Local Enviroment</strong><br />
					<span style="font-family: Consolas,monospace; font-size: 0.8em;">
						syno_token='${syno_token}'<br />
						login_result='${login_result}'<br />
						login_success='${login_success}'<br />
						syno_user='${syno_user}'<br />
						user_exist='${user_exist}'<br />
						is_admin='${is_admin}'<br />
						is_authenticated='${is_authenticated}'<br />
					</span>
					<br />'

					# Group membership
					echo '
					<strong>Group membership</strong></br />
					<span style="font-family: Consolas,monospace; font-size: 0.8em;">'
						if cat /etc/group | grep ^${app_name} | grep -q ${app_name} ; then
							echo ''${app_name}'<br />'
						fi
						if cat /etc/group | grep ^system | grep -q ${app_name} ; then
							echo 'system<br />'
						fi
						if cat /etc/group | grep ^administrators | grep -q ${app_name} ; then
							echo 'administrators<br />'
						fi
						echo '
					</span>
					<br />'

					# Global Enviroment
					echo '
					<strong>Global Enviroment</strong>
					<pre>'; (set -o posix ; set | sed '/txt.*/d;'); echo '</pre>
					<br />'

				else
					# Infotext: Access allowed only for users from the Administrators group
					echo '<p>'${txtAlertOnlyAdmin}'</p>'
				fi
				echo '
			</article>
		</body>
	</html>'
fi
exit
