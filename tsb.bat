@echo off
set EULA=
set mem=
set mcport=
set mcver="1.19"
echo �o�[�W�������擾��...
for /f "usebackq delims=" %%A in (`curl https://api.github.com/repos/ProjectTSB/TheSkyBlessing/releases/latest ^| findstr /r /c:"\"browser_download_url\": \"https://.*\TheSkyBlessing.zip\""`) do set tsblatest=%%A
set tsblatest=%tsblatest: =%
set tsblatest=%tsblatest:"browser_download_url":"=%
set tsblatest=%tsblatest:"=%
set tsbver=%tsblatest:https://github.com/ProjectTSB/TheSkyBlessing/releases/download/=%
set tsbver=%tsbver:/TheSkyBlessing.zip=%
title TSB %tsbver% �Z�b�g�A�b�v

echo.
echo ###############################################################
echo.
echo TSB %tsbver% �����Z�b�g�A�b�v for Windows by 0kq
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

for /f "usebackq delims=" %%A in (`curl https://api.github.com/repos/ProjectTSB/TSB-ResourcePack/releases/latest ^| findstr /r /c:"\"browser_download_url\": \"https://.*\resources.zip\""`) do set tsbrplatest=%%A
set tsbrplatest=%tsbrplatest: =%
set tsbrplatest=%tsbrplatest:"browser_download_url":"=%
set tsbrplatest=%tsbrplatest:"=%

curl -L -o server.jar https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar
cd world
curl -L -o tsb.zip %tsblatest%
call powershell -command "Expand-Archive -Path '.\tsb.zip' -DestinationPath '.\'"
del resources.zip
cd ..
echo @echo off>start.bat
echo title TheSkyBlessing %tsbver% - %mcver%>>start.bat
echo java -Dlog4j2.formatMsgNoLookups=true -Xmx%mem% -Xms%mem% -server -jar server.jar nogui>>start.bat
echo pause>>start.bat
echo eula=true>eula.txt
echo server-port=%mcport%>server.properties
echo gamemode=adventure>>server.properties
echo difficulty=normal>>server.properties
echo resource-pack=%tsbrplatest%>>server.properties
echo motd=\u00A7eThe\u00A7a Sky\u00A7d Blessing \u00a76%tsbver% \u00A7f- \u00A7b%mcver%>>server.properties

echo �\�z���������܂���
set runserver=
set /P runserver="�T�[�o�[���N�����܂����H(y/n): "
if %runserver%==y (
  echo TheSkyBlessing %tsbver%���N����...
  start start.bat
)
pause