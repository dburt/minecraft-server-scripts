#!/bin/bash

set -e

#TODO: keep older versions of Paper, Floodgate, and Geyser

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "usage: $0 [--dry-run]"
    exit
elif [ "$1" == "--dry-run" ]; then
    DryRun=$1
    echo "Dry run -- only checking for new version available, not installing"
elif [ -n "$1" ]; then
    echo "invalid options: $*"
    echo "usage: $0 [--dry-run]" >&2
    exit 1
fi

echo "Updating Paper, Geyser and Floodgate"

echo "Finding latest version of Minecraft/Paper available..."
Version=$(curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" https://papermc.io/api/v2/projects/paper | ruby -rjson -e 'puts JSON.parse(ARGF.read)["versions"].last')
echo "Got Version=${Version}"

# Get latest Paper build
echo "Checking available builds of Paper for version $Version..."
BuildJSON=$(curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" https://papermc.io/api/v2/projects/paper/versions/$Version)
Build=$(echo "$BuildJSON" | rev | cut -d, -f 1 | cut -d']' -f 2 | cut -d'[' -f 1 | rev)
Build=$(($Build + 0))
if [[ $Build != 0 ]]; then
    PaperJar="server_jars/paper-$Version-$Build.jar"
    if [[ -f "$PaperJar" ]]; then
	echo "Paper is already up to date at $Version-$Build"
    else
	echo "Updating Paper to $Version-$Build"
	curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o "$PaperJar" "https://papermc.io/api/v2/projects/paper/versions/$Version/builds/$Build/downloads/paper-$Version-$Build.jar"
	if [[ -L minecraft_server.jar ]]; then
	    rm minecraft_server.jar
	fi
	ln -s "$PaperJar" minecraft_server.jar
    fi
else
    echo "Unable to retrieve latest Paper build (got result of $Build)"
fi

# Update Floodgate if new version is available
echo "Checking for latest Floodgate fingerprint..."
FloodgateMD5=$(curl --no-progress-meter -k -L -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" 'https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar/*fingerprint*/' | ruby -e 'puts ARGF.read[/MD5: (\w+)/, 1]')
if [ -n "$FloodgateMD5" ]; then
    LocalMD5=$(md5sum plugins/floodgate-spigot.jar | cut -d' ' -f1)
    if [ -e plugins/floodgate-spigot.jar ] && [ "$LocalMD5" = "$FloodgateMD5" ]; then
        echo "Floodgate is up to date at $FloodgateMD5"
    else
        echo "Updating Floodgate from $LocalMD5 to $FloodgateMD5..."
        curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o plugins/floodgate-spigot.jar "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar"
    fi
else
    echo "Unable to check for updates to Floodgate!"
fi

# Update Geyser if new version is available
echo "Checking for latest Geyser fingerprint..."
GeyserMD5=$(curl --no-progress-meter -k -L -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" 'https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar/*fingerprint*/' | ruby -e 'puts ARGF.read[/MD5: (\w+)/, 1]')
if [ -n "$GeyserMD5" ]; then
    LocalMD5=$(md5sum plugins/Geyser-Spigot.jar | cut -d' ' -f1)
    if [ -e plugins/Geyser-Spigot.jar ] && [ "$LocalMD5" = "$GeyserMD5" ]; then
        echo "Geyser is up to date at $GeyserMD5"
    else
        echo "Updating Geyser from $LocalMD5 to $GeyserMD5..."
        curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o plugins/Geyser-Spigot.jar "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar"
    fi
else
    echo "Unable to check for updates to Geyser!"
fi

# Update Simple Voice Chat if new version is available
LatestVoicechatUrl=$(curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" https://modrinth.com/plugin/simple-voice-chat/versions\?l\=spigot\&g\=$Version | ruby -rnokogiri -e 'puts Nokogiri::HTML(ARGF.read).css("a.release.download-button").attr("href").value')
if [ -n "$LatestVoicechatUrl" ]; then
    LocalVoicechat="$(echo plugins/voicechat-*)"
    if [ -e "$LocalVoicechat" ] && [ "$(basename $LatestVoicechatUrl)" = "$(basename $LocalVoicechat)" ]; then
        echo "Simple Voice Chat is up to date at $(basename $LatestVoicechatUrl)"
    else
        echo "Updating Simple Voice Chat from $(basename $LocalVoicechat) to $(basename $LatestVoicechatUrl)..."
        curl --no-progress-meter -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o "plugins/$(basename $LatestVoicechatUrl)" "$LatestVoicechatUrl" && mv $LocalVoicechat plugins_available
    fi
else
    echo "Unable to check for updates to Simple Voice Chat!"
fi

echo "Updates complete"

