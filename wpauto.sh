#!/bin/bash -e
clear
echo "============================================"
echo "WordPress auto installer script by ElitAdmin.top"
echo "============================================"
echo "Enter database Name: "
read -e dbname
echo "Enter database User: "
read -e dbuser
echo "Enter database Password: "
read -s dbpass
echo "run install WordPress? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "WordPress auto installer script by ElitAdmin.top"
echo "============================================"
#download latest wordpress
curl -O https://wordpress.org/latest.tar.gz
#unzip fresh wordpress
tar -zxvf latest.tar.gz
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress
#create wp config
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#set WordPress salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Cleaning instalation files..."
#remove zip file
rm latest.tar.gz
#remove bash script
rm wp.sh
echo "========================="
echo "Installation latest wordpress from bash is complete."
echo "========================="
fi
