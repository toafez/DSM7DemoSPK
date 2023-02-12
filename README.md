[English](README_en.md) | Deutsch

# ![Package icon](/package/ui/images/icon_24.png) DSM 7 Paket Entwickler Demo
Mit der „DSM 7 Paketentwickler Demo“ möchte ich allen ambitionierten als auch zukünftigen 3rd-Party Entwicklern eine mögliche Plattform für die Paketentwicklung des DiskStation Manager 7 von Synology anbieten. Dieses Framework basiert dabei auf der jeweils aktuellen, im DSM implementierten BASH Version sowie der textbasierten Auszeichnungssprache HTML. Weitere Script- und/oder Programmiersprachen wie CSS, JavaScript, AJAX, jQuery, Python, Perl etc. sind möglich, kommen hier jedoch nicht zum Einsatz. Grundlegende Abfragen und Routinen, um einen sicheren und reibungslosen Betrieb innerhalb des DSM zu gewährleisten, sind bereits implementiert und in den Scripten entsprechend kommentiert. Dazu gehört u.a. ...

  - #### Systemberechtigungen (Privilegien)
    Mit Einführung von DSM 7 erhält eine Anwendung (im folgenden App genannt) nur noch dann root Berechtigungen, wenn Synology dies explizit genehmigt. In allen anderen Fällen ist eine App dazu gezwungen, ihre Privilegien so weit zu senken, das diese nur noch mit stark eingeschränkten Benutzer- und Gruppenrechten auskommen muss. Um diese restriktiven Privilegien ein wenig zu lockern, besteht die Möglichkeit, die App in weitere Gruppen, wie z.B. der Gruppe der Administratoren aufzunehmen. Eine entsprechende Funktion zum hinzufügen bzw. entfernen wurde in die App integriert und kann optional über ein kleines Script angepasst und ausgeführt werden.

  - #### Anwendungsberechtigungen (SynoToken)
    Ist in der DSM Systemsteuerung der „Schutz gegen Cross-Site Request Forgery Attacken verbessern“ aktiviert, müssen sich DSM Apps am System mit einen entsprechenden Token (Synology nennt ihn SynoToken) authentifizieren. Ist das der Fall, wird der SynoToken innerhalb der App ausgewertet und mit dem QUERY_STRING SynoToken=[token] an die URL angehangen.

  - #### Benutzerberechtigung (Authentifizierung)
    Des Weiteren wird geprüft, ob ein, am DSM angemeldeter Benutzer existiert, ob dieser der Gruppe der Administratoren angehört und privilegiert ist, die App zu nutzen.

  - #### GET-/POST-Request Engine
    Implementierung einer GET-/POST-Request Engine um anfallende Formulardaten, Parameterübergaben und Seitenaufrufe zu verarbeiten, wobei sämtliche Formulardaten über die POST-Methode, an Links angegangene Variablen über die GET-Methode übertragen werden. Aus Gründen der Sicherheit werden alle übertragenen Variablen intern durch ein assoziatives Array maskiert bevor diese weiterverarbeitet werden.

  - #### Spracheinstellungen
    Die GUI ist für Mehrsprachigkeit ausgelegt und wird der Systemsprache des DSM angepasst.

# Systemvoraussetzungen
**„DSM 7 Paketentwickler Demo“** wurde speziell für die Verwendung auf **Synology NAS Systemen** entwickelt die das Betriebsystem **DiskStation Mangager 7** verwenden.

## Umbauen des Paketes für die eigene Verwendung  
Für die nachfolgende Anleitung wird ein entsprechendes **Linux** System vorausgesetzt. Ebenfalls sollte einem der Umgang mit dem Linux **Terminal** vertraut sein.

  - Klone das Repository oder lade dir die entsprechende ZIP-Datei herunter und entpacke das Archiv in einen Ordner deiner Wahl.

  - Wechsle in den Ordner des geklonten bzw. entpackten Repositorys.

  - Mach das Script SPK_Build_Stage.sh ausführbar.

    `chmod +x SPK_Build_Stage.sh`

  - Falls gewünscht, kannst du den Namen des Paketes, den Namen des Maintrainers, den Copyright Hinweis sowie die Ordner- und Dateirechte ändern, indem du das Script SPK_Build_Stage.sh mit einem Editor deiner Wahl aufrufst und die nachfolgenden Variabeln entsprechend anpasst. 

    `packagename="DSM7DemoSPK"`
    `copyright="Copyright (C) 2023 by"`
    `maintrainer="Tommes"`
    `changedirname="no"` 

  - Führe nun das Script SPK-Build_Stage.sh aus.

    `./SPK_Build_Stage.sh`

  - Nach der Ausführung wurde ggf. der Name des Repositorys Ordners verändert. Ist dies der Fall, wechselt das Script automatisch in den neu erstellten Ordner.

## Packen des Paketes unter Verwendung eines selbst geschriebenen Scriptes
  - Wechsle wieder in den Ordner des geklonten, entpackten bzw. umgebauten Repositorys.

  - Mach das Script SPK_Pack_Stage.sh ausführbar.

    `chmod +x SPK_Pack_Stage.sh`

  - Falls gewünscht, kannst du den Namen des Paketes sowie die Versionsnummer ändern, indem du das Script SPK_Pack_Stage.sh mit einem Editor deiner Wahl aufrufst und die nachfolgenden Variabeln entsprechend anpasst. 

    `package_name="DSM7DemoSPK"`
    `version="0.1-000"`

  - Führe nun das Script SPK-Pack_Stage.sh aus.

    `./SPK_Pack_Stage.sh`

  - Nach der Ausführung wurde ein Paket mit dem entsprechenden Namen erstellt, welches die Dateiendung .spk trägt. Beispiel DSM7DemoSPK-0.1-000.spk

  - Jetzt kannst du das Paket über das DSM-Paket Zentrum installieren. Öffne dazu im **DiskStation Manager (DSM)** das **Paket-Zentrum**, wähle oben rechts die Schaltfläche **Manuelle Installation** aus und folge dem **Assistenten**, um das neue **Paket** bzw. die entsprechende **.spk-Datei** hochzuladen und zu installieren. Dieser Vorgang ist sowohl für eine Erstinstallation als auch für die Durchführung eines Updates identisch. 

 - Der Speicherort des Paketes im System des DSM befindet sich unter 

    `/var/packages/[Package Name]`

    … bzw. unter...

    `/var/packages/[Package Name]/target`
 
## Packen des Paketes unter Verwendung des Synology DSM 7.0 Developer Guides
Das Repository kann auch mittels toolkit/toolchain wie im [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/) beschrieben, packen. Sämtliche Informationen sind dem Guide entsprechend zu entnehmen. 


# App-Berechtigung erweitern bzw. beschränken
Unter DSM 7 wird eine 3rd_Party Anwendung wie „DSM 7 Paket Entwickler Demo“ (im folgenden App genannt) mit stark eingeschränkten Benutzer- und Gruppenrechten ausgestattet. Dies hat u.a. zur Folge, das systemnahe Befehle nicht ausgeführt werden können. Für den reibungslosen Betrieb von „DSM 7 Paket Entwickler Demo“ werden jedoch erweiterte Systemrechte benötigt um z.B. auf die Ordnerstuktur der "freigegebenen Ordner" zugreifen zu können. Zum erweitern der App-Berechtigungen muss „DSM 7 Paket Entwickler Demo“ in die Gruppe der Administratoren aufgenommen werden, was jedoch nur durch den Benutzer selbst durchgeführt werden kann. Die nachfolgende Anleitung beschreibt diesen Vorgang.

  - #### Erweitern bzw. beschränken der App-Berechtigungen über die Konsole

    - Melden Sie sich als Benutzer **root** auf der Konsole Ihrer Synology NAS an.
    - Befehl zum erweitern der App-Berechtigungen

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "adduser"`

    - Befehl zum beschränken der App-Berechtigungen

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "deluser"`

  - #### Erweitern bzw. beschränken der App-Berechtigungen über den Aufgabenplaner

    - Im **DSM** unter **Hauptmenü** > **Systemsteuerung** den **Aufgabenplaner** öffnen.
    - Im **Aufgabenplaner** über die Schaltfläche **Erstellen** > **Geplante Aufgabe** > **Benutzerdefiniertes Script** auswählen.
    - In dem nun geöffneten Pop-up-Fenster im Reiter **Allgemein** > **Allgemeine Einstellungen** der Aufgabe einen Namen geben und als Benutzer: **root** auswählen. Außerdem den Haken bei Aktiviert entfernen.
    - Im Reiter **Aufgabeneinstellungen** > **Befehl ausführen** > **Benutzerdefiniertes Script** nachfolgenden Befehl in das Textfeld einfügen...
    - Befehl zum erweitern der App-Berechtigungen

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "adduser"`

    - Befehl zum beschränken der App-Berechtigungen

      `/usr/syno/synoman/webman/3rdparty/DSM7DemoSPK/app_permissions.sh "deluser"`

    - Eingaben mit **OK** speichern und die anschließende Warnmeldung ebenfalls mit **OK** bestätigen.
    - Die grade erstellte Aufgabe in der Übersicht des Aufgabenplaners markieren, jedoch **nicht** aktivieren (die Zeile sollte nach dem markieren blau hinterlegt sein).
    - Führen Sie die Aufgabe durch Betätigen Sie Schaltfläche **Ausführen** einmalig aus.

# Versionsgeschichte
- Details zur Versionsgeschichte finden Sie in der Datei [CHANGELOG](CHANGELOG).

# Entwickler-Information
- Details zum Backend entnehmen Sie bitte dem [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/)

# Lizenz
Dieses Programm ist freie Software. Sie können es unter den Bedingungen der **GNU General Public License**, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß **Version 3** der Lizenz oder (nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein wird, aber **OHNE IRGENDEINE GARANTIE**, sogar **ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK**. Details finden Sie in der Datei [GNU General Public License](LICENSE).
