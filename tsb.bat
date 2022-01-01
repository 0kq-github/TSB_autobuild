@echo off
set EULA=
set mem=
set mcport=
set tsbver=The Sky Blessing v0.0.1

echo ###############################################################
echo.
echo TSB v0.0.1 �����Z�b�g�A�b�v for Windows by 0kq
echo �{��URL https://tsb.scriptarts.jp/
echo eula https://www.minecraft.net/ja-jp/terms/r3/
echo.
echo ###############################################################

if exist "tsb_autobuild" (
  set exist=
  set /P exist="�T�[�o�[�����݂��܂��B�T�[�o�[���N�����܂����H(y/n): "
) else (
  set exist=null
  call:build
)

if %exist%==y (
  cd tsb_autobuild
  start start.bat
  exit
) else if %exist%==n (
  set rebuild=
  set /P rebuild="�T�[�o�[���č\�z���܂����H �č\�z����ꍇ���݂̃T�[�o�[�͍폜����܂� (y/n): "
) else (
  rebuild=null
)

if %rebuild%==y (
  echo �T�[�o�[���폜��...
  rd /s /q tsb_autobuild
  call:build
)

pause
exit

:build
set /P EULA="eula�ɓ��ӂ��܂����H(y/n): "
if not %EULA%==y (
  echo eula�ɓ��ӂ���K�v������܂�
  pause
  exit
)
set /P mem="���������蓖�ė�(�P�ʍ��݂œ��͂��Ă������� ��:4G ): "
set /P mcport="�N������|�[�g: "
mkdir tsb_autobuild
cd tsb_autobuild
mkdir world
curl -L -o server.jar https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
cd world
curl -L -o tsb.zip https://github.com/ProjectTSB/TheSkyBlessing/releases/download/v0.0.1/TheSkyBlessing.zip
call powershell -command "Expand-Archive -Path '.\tsb.zip' -DestinationPath '.\'"
cd ..
echo @echo off>start.bat
echo title %tsbver% - 1.17.1>>start.bat
echo java -Dlog4j2.formatMsgNoLookups=true -Xmx%mem% -Xms%mem% -server -jar server.jar nogui>>start.bat
echo pause>>start.bat
echo eula=true>eula.txt
echo server-port=%mcport%>server.properties
echo gamemode=adventure>>server.properties
echo difficulty=normal>>server.properties
echo motd=\u00A7eThe\u00A7a Sky\u00A7d Blessing \u00a76v0.0.1 \u00A7f- \u00A7b1.17.1>>server.properties

echo �\�z���������܂���
set runserver=
set /P runserver="�T�[�o�[���N�����܂����H(y/n): "
if %runserver%==y (
  echo %tsbver%���N����...
  start start.bat
)
pause