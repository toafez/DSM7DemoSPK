English | [Deutsch](README.md)

# ![Package icon](/ui/images/icon_24.png) DSM 7 Package Developer Demo
With the "DSM 7 Package Developer Demo" I would like to offer all ambitious as well as future 3rd party developers a possible platform for the package development of Synology's DiskStation Manager 7. This framework is based on the current BASH version implemented in DSM and the text based HTML markup language. Other script and/or programming languages such as CSS, JavaScript, AJAX, jQuery, Python, Perl etc. are possible, but are not used here. Basic queries and routines to ensure safe and smooth operation within the DSM are already implemented and commented accordingly in the scripts. This includes among other things...

  - #### System permissions (privileges)
    With the introduction of DSM 7, an application (referred to as an app in the following) will only be granted root privileges if Synology explicitly approves it. In all other cases, an app is forced to lower its privileges to the point where it only has to manage with highly restricted user and group rights. In order to loosen these restrictive privileges a bit, it is possible to add the app to additional groups, such as the administrators group. A corresponding add/remove function has been integrated into the app and can optionally be customized and executed via a small script.

  - #### Application Authorizations (SynoToken)
    If "Improve protection against cross-site request forgery attacks" is enabled in the DSM Control Panel, DSM apps must authenticate themselves to the system with an appropriate token (Synology calls it SynoToken). If this is the case, the SynoToken is evaluated within the app and appended to the URL with the QUERY_STRING SynoToken=[token].

  - #### User authorization (authentication)
    Furthermore, it is checked whether a user logged on to the DSM exists, whether this user belongs to the group of administrators and is privileged to use the app.

  - #### GET/POST request engine
    Implementation of a GET-/POST-Request Engine to process incoming form data, parameter transfers and page requests. All form data is transferred via the POST method, variables addressed to links via the GET method. For security reasons, all transferred variables are masked internally by an associative array before they are processed further.

  - #### Language settings
    The GUI is designed for multilingualism and is adapted to the system language of the DSM.

# System requirements
**„DSM 7 Package Developer Demo“** is specifically designed for use on **Synology NAS systems** that use the **DiskStation Mangager 7** operating system.

## Modify the package for your own use.  
For the following instructions an appropriate **Linux** system is required. You should also be familiar with the Linux **Terminal**. 

  - Clone the repository or download the corresponding ZIP file and unpack the archive into a folder of your choice.

  - Change to the folder of the cloned or unzipped repository.

  - Make the script SPK_Build_Stage.sh executable.

    `chmod +x SPK_Build_Stage.sh`

  - If desired, you can change the name of the package, the name of the maintrainer, the copyright notice and the folder and file permissions by running the script SPK_Build_Stage.sh with an editor of your choice and changing the following variables accordingly.

    `packagename="DSM7DemoSPK"`
    
    `copyright="Copyright (C) 2023 by"`
    
    `maintrainer="Tommes"`
    
    `changedirname="no"` 

  - Now run the script SPK-Build_Stage.sh.

    `./SPK_Build_Stage.sh`.

  - After execution, the name of the repository folder may have been changed. If this is the case, the script automatically changes to the newly created folder.

## Pack the package using a script you wrote yourself.
  - Change back to the folder of the cloned, unpacked or rebuilt repository.

  - Make the script SPK_Pack_Stage.sh executable.

    `chmod +x SPK_Pack_Stage.sh`

  - If desired, you can change the name of the package as well as the version number by calling the script SPK_Pack_Stage.sh with an editor of your choice and changing the following variables accordingly. 

    `package_name="DSM7DemoSPK"`
    
    version="0.1-000"`

  - Now execute the script SPK-Pack_Stage.sh.

    `./SPK_Pack_Stage.sh`

  - After execution a package with the appropriate name was created, which has the file extension .spk. Example DSM7DemoSPK-0.1-000.spk

  - Now you can install the package via the DSM package center. To do this, open the **Package Center** in **DiskStation Manager (DSM)**, select the **Manual Installation** button in the upper right corner and follow the **Wizard** to upload and install the new **package** or the corresponding **.spk file**. This process is identical for both an initial installation and for performing an update. 

  - The location of the package in the system of the DSM is under 

      `/var/packages/[package name]`

      ... or under...

       `/var/packages/[Package Name]/target/ui`

## Packing the package using the Synology DSM 7.0 Developer Guide.
The repository can also be packaged using toolkit/toolchain as described in the [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/). All information can be found in the guide accordingly. 

# Extending or restricting app permission
Under DSM 7, a 3rd_Party application such as „DSM 7 Package Developer Demo“ (referred to as App in the following) is provided with highly restricted user and group rights. Among other things, this means that system-related commands cannot be executed. For the smooth operation of „DSM 7 Package Developer Demo“, however, extended system rights are required, e.g. to be able to access the folder structure of the "shared folders". To extend the app permissions, „DSM 7 Package Developer Demo“ must be added to the administrators' group, but this can only be done by the user himself. The following instructions describe this process.

  - #### Extending or restricting app permissions via the console

    - Log in to the console of your Synology NAS as user **root**.
    - Command to extend app permissions

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "adduser"`

    - Command to restrict app permissions

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "deluser"`

  - #### Extend or restrict app permissions via the task planner

    - Open the **Task Scheduler** in **DSM** under **Main Menu** > **Control Panel**.
    - In the **Task Scheduler**, select **Create** > **Scheduled Task** > **Custom Script** via the button.
    - In the pop-up window that now opens in the **General** > **General Settings** tab, give the task a name and select **root** as the user: **root** as the user. Also remove the tick from Activated.
    - In the **Task Settings** tab > **Execute Command** > **Custom Script**, insert the following command into the text field...
    - Command to extend the app permissions

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "adduser"`

    - Command to restrict app permissions

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "deluser"`

    - Save the entries with **OK** and confirm the subsequent warning message with **OK**.
    - Mark the task you have just created in the overview of the task planner, but **do not** activate it (the line should be highlighted in blue after marking).
    - Execute the task once by pressing the **Execute** button.

# Version history
- Details of the version history can be found in the file [CHANGELOG](CHANGELOG).

# Developer information
- For backend details, please refer to the [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/)

# License
This program is free software. You can redistribute it and/or modify it under the terms of the **GNU General Public License** as published by the Free Software Foundation; either **version 3** of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful to you, but ** WITHOUT ANY WARRANTY**, even **without the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE**. For details, see the [GNU General Public License](LICENSE) file.
