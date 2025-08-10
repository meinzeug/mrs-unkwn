Set-StrictMode -Version Latest
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AppDir = Join-Path $ScriptDir "..\flutter_app\mrs_unkwn_app"
Set-Location $AppDir
flutter clean
flutter pub get
dart run tool/fix_android_namespaces.dart
flutter build apk --release
