@echo off
echo Launching Android Emulator...

:: Launch your emulator by name (change to match your setup)
flutter emulators --launch Pixel_9

:: Wait for emulator to boot (adjust time if needed)
timeout /t 10 >nul

echo Running Flutter app...
flutter run
pause
