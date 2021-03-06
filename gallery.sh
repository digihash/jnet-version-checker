#!/bin/sh

# Zoeken naar Gallery 3.x instalaties:

for domain in `locate modules/gallery/helpers/gallery.php`
do
	#echo $domain
	domain2=`echo $domain | awk -F "modules/gallery/helpers/gallery.php" '{print $1}'`
	echo $domain2
	cat $domain  | grep -E "const VERSION" | awk -F " VERSION = \"" '{print $2}' | awk -F "\";"  '{print $1}'
done


# Zoeken naar Gallery 2.x instalaties:

for domain in `locate modules/core/AdminCore.inc`
do
	# /var/www/vhosts/os.jnet.be/httpdocs/gallery2/modules/core/AdminCore.inc
	domain=`echo $domain | awk -F "modules/core/AdminCore.inc" '{print $1}'`
	echo $domain
	hostname=`cat ${domain}config.php | grep "storeConfig" | grep "hostname" | awk -F "= '" '{print $2}' | awk -F "';" '{print $1}'`
	database=`cat ${domain}config.php | grep "storeConfig" | grep "database" | awk -F "= '" '{print $2}' | awk -F "';" '{print $1}'`
	username=`cat ${domain}config.php | grep "storeConfig" | grep "username" | awk -F "= '" '{print $2}' | awk -F "';" '{print $1}'`
	password=`cat ${domain}config.php | grep "storeConfig" | grep "password" | awk -F "= '" '{print $2}' | awk -F "';" '{print $1}'`
	echo "hostname: $hostname";
	echo "database: $database";
	echo "username: $username";
	echo "password: $password";
	version=`mysql -u $username -D$database -h $hostname -p$password --skip-column-names -e "SELECT g_packageVersion FROM g2_PluginPackageMap WHERE g_pluginType='module' AND g_pluginId='core'"`
	if [ -n "$version" ]; then
		#version=`echo $version | grep "module" | grep "core" | awk '{print $4}'`
		echo "version: $version";
	else
		echo "Problem while connecting with the database"
	fi
done

