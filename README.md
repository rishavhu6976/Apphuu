# HAU Anime - Android app

A native shell (WebView) around your HAU Anime server: full-screen landscape video, back button, saved login, offline page.
It loads the server address baked in at build time (default `http://13.239.14.222:8765`), so site updates show up in the app instantly.

## Build option A - on your Ubuntu server
```bash
unzip hau-anime-android.zip && cd hau-anime-android
./build-apk.sh http://13.239.14.222:8765      # 5-10 min the first time
cp hau-anime.apk ~/h/hau-anime/static/        # adjust to where your hau-anime folder is
```
On your phone open `http://13.239.14.222:8765/static/hau-anime.apk`, install it (allow "install unknown apps" for Chrome),
then delete the file from the server: `rm ~/h/hau-anime/static/hau-anime.apk`.

## Build option B - GitHub (nothing to install)
1. Create a private repo, upload this folder's contents (keep `.github/`).
2. Actions tab -> "Build APK" -> Run workflow -> download artifact `hau-anime-apk` (contains `app-debug.apk`).
3. Different server address: Settings -> Secrets and variables -> Actions -> Variables -> `HAU_URL`.

## Build option C - Android Studio
Open this folder, Build -> Build APK(s). Change the address with `-PHAU_URL=...` or in `app/build.gradle`.

## Notes
- Debug-signed APK: fine for installing on your own devices; not for the Play Store.
- Cleartext HTTP is enabled because the server has no HTTPS yet. After adding HTTPS, rebuild with the https address.
- Android 7.0+ (minSdk 24).
