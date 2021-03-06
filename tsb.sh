#!/bin/bash
mcver="1.19"

function build () {
 read -p "eulaに同意しますか？(y/n): " eula
 if [ $eula = y ]; then
  :
 else
  echo "eulaに同意する必要があります"
  exit
 fi
 read -p "メモリ割り当て量(単位込みで入力してください 例:4G ): " mem
 read -p "起動するポート: " mcport
 java -version &> /dev/null
 if [ $? -ne 0 ] ; then
  read -p "javaのインストールを行いますか？(y/n): " javainst
 else
  :
 fi
 mkdir tsb_autobuild
 chmod 777 tsb_autobuild
 cd tsb_autobuild
 mkdir world
 if [ $javainst = y ] ; then
  yum install -y java-17-openjdk-headless
  apt install -y openjdk-17-jre-headless
 else
  :
 fi
 unzip -hh &> /dev/null
 if [ $? -ne 0 ] ; then
  yum install -y unzip
  apt install -y unzip
 else
  :
 fi
 tsbrplatest=$(curl -s https://api.github.com/repos/ProjectTSB/TSB-ResourcePack/releases/latest | grep "resources.zip" | cut -d : -f 2,3 | tr -d \" | grep "/resources\.zip")
 wget -O server.jar https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar
 cd world
 wget -O tsb.zip $tsblatest
 unzip tsb.zip
 rm resources.zip
 cd ..
 echo java -Dlog4j2.formatMsgNoLookups=true -Xmx$mem -Xms$mem -server -jar server.jar nogui > start.sh
 echo "server-port=${mcport}" > server.properties
 echo "gamemode=adventure" >> server.properties
 echo "difficulty=normal" >> server.properties
 echo "resource-pack=$tsbrplatest" >> server.properties
 echo "motd=\u00A7eThe\u00A7a Sky\u00A7d Blessing \u00a76$tsbversion \u00A7f- \u00A7b$mcver" >> server.properties
 chmod 777 start.sh
 echo "eula=true" > eula.txt
 echo "構築が完了しました"
 read -p "サーバーを起動しますか？(y/n): " runserver 
 if [ $runserver = y ] ; then
  echo "TSB $tsbversionを起動中..."
  ./start.sh
 else
  :
 fi
}


if [ $USER = root ]; then
 tsblatest=$(curl -s https://api.github.com/repos/ProjectTSB/TheSkyBlessing/releases/latest | grep "TheSkyBlessing.zip" | cut -d : -f 2,3 | tr -d \" | grep "/TheSkyBlessing\.zip")
 tsbversion=$(echo $tsblatest | grep -oE "v[0-9]*.[0-9]*.[0-9]*")
 echo "###############################################################"
 echo ""
 echo "TSB $tsbversion 自動セットアップ for Linux by 0kq"
 echo "本家URL https://tsb.scriptarts.jp/"
 echo "eula https://www.minecraft.net/ja-jp/terms/r3/"
 echo ""
 echo "###############################################################"
 if [ -d "tsb_autobuild" ]; then
  read -p "サーバーが存在します。サーバーを起動しますか？(y/n): " exist
 else
  exist=null
  build
 fi
 if [ $exist = y ]; then
  cd tsb_autobuild
  ./start.sh
  exit
 elif [ $exist = n ]; then
  read -p "サーバーを再構築しますか？ 再構築する場合現在のサーバーは削除されます (y/n): " rebuild
 else
  rebuild=null
 fi
 if [ $rebuild = y ]; then
  rm -rf tsb_autobuild
  build
 else
  :
 fi

else
 echo "root権限が必要です"
 echo "sudo ./tsb.sh又はrootユーザーで実行してください"
fi