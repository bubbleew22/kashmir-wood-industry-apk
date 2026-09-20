@echo off
setlocal EnableDelayedExpansion
title Kashmir Wood Industry - APK Setup
color 0A

echo.
echo ============================================================
echo    Kashmir Wood Industry - APK Builder Setup
echo ============================================================
echo.

cd /d "%~dp0"

:: Check index.html
if not exist "index.html" (
    if not exist "www\index.html" (
        echo [ERROR] index.html not found in this folder!
        echo Please place this .bat file in the same folder as index.html
        pause
        exit /b 1
    )
)

:: Check git
where git >nul 2>nul
if errorlevel 1 (
    echo [WARNING] Git is not installed!
    echo Download: https://git-scm.com/download/win
    echo.
)

echo [1/6] Creating folder structure...
if not exist "www" mkdir www
if not exist ".github" mkdir .github
if not exist ".github\workflows" mkdir .github\workflows

echo [2/6] Moving index.html to www/...
if exist "www\index.html" del /F /Q "www\index.html" >nul 2>&1
if exist "index.html" move /Y "index.html" "www\index.html" >nul

echo [3/6] Creating package.json...
(
echo {
echo   "name": "kashmir-wood-industry",
echo   "version": "1.0.0",
echo   "description": "Kashmir Wood Industry Production Report",
echo   "private": true,
echo   "scripts": {
echo     "build": "echo Building..."
echo   },
echo   "dependencies": {
echo     "@capacitor/android": "^5.7.0",
echo     "@capacitor/cli": "^5.7.0",
echo     "@capacitor/core": "^5.7.0"
echo   }
echo }
) > package.json

echo [4/6] Creating capacitor.config.json...
(
echo {
echo   "appId": "com.kashmir.woodindustry",
echo   "appName": "Kashmir Wood Industry",
echo   "webDir": "www",
echo   "bundledWebRuntime": false,
echo   "server": {
echo     "androidScheme": "https"
echo   }
echo }
) > capacitor.config.json

echo [5/6] Creating GitHub Actions workflow...
(
echo name: Build Android APK
echo.
echo on:
echo   push:
echo     branches: [ main, master ]
echo   workflow_dispatch:
echo.
echo jobs:
echo   build:
echo     runs-on: ubuntu-latest
echo     steps:
echo       - name: Checkout Code
echo         uses: actions/checkout@v4
echo.
echo       - name: Setup Node.js
echo         uses: actions/setup-node@v4
echo         with:
echo           node-version: '18'
echo.
echo       - name: Setup Java JDK 17
echo         uses: actions/setup-java@v4
echo         with:
echo           distribution: 'temurin'
echo           java-version: '17'
echo.
echo       - name: Setup Android SDK
echo         uses: android-actions/setup-android@v3
echo.
echo       - name: Install npm packages
echo         run: npm install
echo.
echo       - name: Add Android platform
echo         run: npx cap add android
echo.
echo       - name: Copy web assets
echo         run: npx cap copy android
echo.
echo       - name: Sync Capacitor
echo         run: npx cap sync android
echo.
echo       - name: Build Debug APK
echo         run: |
echo           cd android
echo           chmod +x gradlew
echo           ./gradlew assembleDebug
echo.
echo       - name: Upload APK artifact
echo         uses: actions/upload-artifact@v4
echo         with:
echo           name: Kashmir-Wood-Industry-APK
echo           path: android/app/build/outputs/apk/debug/app-debug.apk
echo           retention-days: 90
) > .github\workflows\build-apk.yml

echo [6/6] Creating .gitignore and README...
(
echo node_modules/
echo android/
echo .gradle/
echo *.log
echo .DS_Store
echo Thumbs.db
) > .gitignore

(
echo # Kashmir Wood Industry - Android APK
echo.
echo Ye repository automatically GitHub Actions ke zariye Android APK build karti hai.
echo.
echo ## APK Download Kaise Karein
echo.
echo 1. Repository ke **Actions** tab par jayen
echo 2. Latest **Build Android APK** workflow run kholein
echo 3. Neeche **Artifacts** section mein **Kashmir-Wood-Industry-APK** download karein
echo 4. ZIP extract karein - andar `app-debug.apk` milegi
echo 5. Mobile mein install karein (Unknown Sources enable karke^)
echo.
echo ## Developer
echo Yasir Khan
) > README.md

echo.
echo ============================================================
echo    SETUP COMPLETE!
echo ============================================================
echo.
echo Folder Structure ab ye hai:
echo.
echo   pro\
echo   ├── www\index.html
echo   ├── .github\workflows\build-apk.yml
echo   ├── package.json
echo   ├── capacitor.config.json
echo   ├── .gitignore
echo   └── README.md
echo.
echo ============================================================
echo    AB YE KAREIN (Next Steps)
echo ============================================================
echo.
echo 1. GitHub par naya repository banayen:
echo    https://github.com/new
echo    Repository name: kashmir-wood-industry-apk
echo    Public ya Private - koi bhi
echo.
echo 2. Repository URL copy karein
echo.
echo 3. CMD mein ye commands run karein:
echo.
echo    git init
echo    git add .
echo    git commit -m "Initial commit - APK setup"
echo    git branch -M main
echo    git remote add origin https://github.com/YOUR_USERNAME/kashmir-wood-industry-apk.git
echo    git push -u origin main
echo.
echo 4. Push ke baad GitHub Actions APK build karega
echo    5-10 minute mein ready ho jaayega
echo.
echo ============================================================
echo.

:: Auto-open GitHub new repo page
choice /C YN /M "GitHub new repo page ab kholein"
if errorlevel 2 goto skipOpen
start https://github.com/new

:skipOpen
echo.
echo Setup complete! 
pause