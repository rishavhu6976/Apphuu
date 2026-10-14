#!/usr/bin/env bash
# Builds hau-anime.apk on an Ubuntu server.   Usage: ./build-apk.sh [http://SERVER_IP:8765]
set -euo pipefail
URL="${1:-http://13.239.14.222:8765}"
cd "$(dirname "$0")"
TOOLS="$HOME/android-tools"; SDK="$TOOLS/sdk"; GRADLE_V=8.7

# Gradle needs ~2 GB: add swap on small servers
if [ "$(free -m | awk '/Mem:/{print $2}')" -lt 2500 ] && ! swapon --show | grep -q .; then
  echo ">> adding 3 GB swap"; sudo fallocate -l 3G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
fi

echo ">> installing Java 17"
sudo apt-get update -y && sudo apt-get install -y openjdk-17-jdk-headless unzip wget zip

mkdir -p "$SDK/cmdline-tools"
if [ ! -d "$SDK/cmdline-tools/latest" ]; then
  echo ">> downloading Android command-line tools"
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cl.zip
  rm -rf /tmp/clt && unzip -q /tmp/cl.zip -d /tmp/clt && mv /tmp/clt/cmdline-tools "$SDK/cmdline-tools/latest"
fi
export ANDROID_HOME="$SDK"
set +o pipefail; yes | "$SDK/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null; set -o pipefail
"$SDK/cmdline-tools/latest/bin/sdkmanager" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

if [ ! -d "$TOOLS/gradle-$GRADLE_V" ]; then
  echo ">> downloading Gradle $GRADLE_V"
  wget -q "https://services.gradle.org/distributions/gradle-$GRADLE_V-bin.zip" -O /tmp/gradle.zip && unzip -q /tmp/gradle.zip -d "$TOOLS"
fi

echo "sdk.dir=$SDK" > local.properties
echo ">> building (first run takes 5-10 minutes)"
"$TOOLS/gradle-$GRADLE_V/bin/gradle" --no-daemon -PHAU_URL="$URL" assembleDebug
cp app/build/outputs/apk/debug/app-debug.apk hau-anime.apk
echo; echo "DONE -> $(pwd)/hau-anime.apk  ($(du -h hau-anime.apk | cut -f1))"
