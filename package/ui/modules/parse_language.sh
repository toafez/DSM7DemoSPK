#!/bin/bash
# Filename: parse_language.sh - coded in utf-8

#                SPKdevDSM7
#
#        Copyright (C) 2022 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html


# Spracheinstellungen konfigurieren
# --------------------------------------------------------------

#********************************************************************#
#  Description: Script get the current used dsm language             #
#  Author:      QTip from the german Synology support forum          #
#  Copyright:   2016-2018 by QTip / Modified 2022 by Tommes          #
#  License:     GNU GPLv3                                            #
#  ----------------------------------------------------------------  #
#  Version:     0.15 - 11/06/2018                                    #
#********************************************************************#

# Declare translation table
declare -A ISO2SYNO
ISO2SYNO=( ["de"]="ger" ["en"]="enu" ["zh"]="chs" ["cs"]="csy" ["jp"]="jpn" ["ko"]="krn" ["da"]="dan" ["fr"]="fre" ["it"]="ita" ["nl"]="nld" ["no"]="nor" ["pl"]="plk" ["ru"]="rus" ["sp"]="spn" ["sv"]="sve" ["hu"]="hun" ["tr"]="trk" ["pt"]="ptg" )

# Standard language
default_lang="enu"

# Script language
script_lang=$(/bin/get_key_value /etc/synoinfo.conf maillang)
if [ "${script_lang}" == "def" ]; then
	script_lang="${default_lang}"
fi

# DSM language
gui_lang=$(/bin/get_key_value /etc/synoinfo.conf language)
if [[ "${gui_lang}" == "def" ]] ; then
	# Determine Browser language
	if [ -n "${HTTP_ACCEPT_LANGUAGE}" ] ; then
		bl=$(echo ${HTTP_ACCEPT_LANGUAGE} | cut -d "," -f1)
		bl=${bl:0:2}
		gui_lang="${ISO2SYNO[${bl}]}"
	else
		gui_lang="${default_lang}"
	fi
fi

# Load language file
if [ -f "lang/lang_${gui_lang}.txt" ]; then
	source "lang/lang_${gui_lang}.txt"
fi
