rem add tools to path
set path=C:\Program Files\7-Zip;%path%
set path=C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64;%path%

rem these values defined outside this repo
set pfxpath=%OK_cert_path%
set pfxpassword=%OK_cert_password%

rem create working directory
set tempdir=temp
md %tempdir%

rem extract appx, then delete
7z.exe x %1 -o%tempdir%
del %1

rem replace godot's angle with nugets
7z e angle.windowsstore.2.1.13.nupkg bin\UAP\x64\libGLESv2.dll -o%tempdir%
7z e angle.windowsstore.2.1.13.nupkg bin\UAP\x64\libEGL.dll -o%tempdir%

rem pack and sign appx
MakeAppx pack /d %tempdir% /p %1
SignTool sign /fd SHA256 /a /f %pfxpath% /p %pfxpassword% %1

pause
rd /S /Q %tempdir%

pause