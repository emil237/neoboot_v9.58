#!/bin/bash
# ###############################################
# SCRIPT : DOWNLOAD AND INSTALL NEOBOOT
# ###########################################
NEOBOOT='v9.58'
###########################################
# Configure where we can find things here #
MY_EM="*****************************************************************************************************"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot'
##########################################
REQUIRED='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot/files'
##########################################
TOOLS='/usr/lib/enigma2/python/Tools'
PREDION='/usr/lib/periodon'
##########################################
URL='https://raw.githubusercontent.com/emilnabil/neoboot_v9.58/main'
##########################################
PYTHON_VERSION=$(python -c"import platform; print(platform.python_version())")

###########################################

# remove old version
if [ -d $PLUGIN_PATH ]; then
   rm -rf $PLUGIN_PATH 
fi

# Python Version Check #
if python --version 2>&1 | grep -q '^Python 3\.'; then
   echo "You have Python3 image"
   PYTHON='PY3'
else
   echo "You have Python2 image"
   PYTHON='PY2'
fi
#########################

VERSION=$NEOBOOT

#######################################
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install --force-overwrite --force-reinstall'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#########################
case $(uname -m) in
armv7l*) plarform="armv7" ;;
mips*) plarform="mipsel" ;;
aarch64*) plarform="ARCH64" ;;
sh4*) plarform="sh4" ;;
esac

#########################
install() {
    if grep -qs "Package: $1" $STATUS; then
        echo
    else
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Need to install $1   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGINSTAL "$1"
            sleep 1
            clear
        fi
    fi
}

#########################
if [ $PYTHON = "PY3" ]; then
    for i in kernel-module-nandsim mtd-utils-jffs2 lzo python-setuptools util-linux-sfdisk packagegroup-base-nfs ofgwrite bzip2 mtd-utils mtd-utils-ubifs; do
        install $i
    done
else
    for i in kernel-module-nandsim mtd-utils-jffs2 lzo python-setuptools util-linux-sfdisk packagegroup-base-nfs ofgwrite bzip2 mtd-utils mtd-utils-ubifs; do
        install $i
    done
fi

#########################
clear


sleep 5
opkg update
opkg install wget
opkg install curl
echo "   UPLOADED BY  >>>>   EMIL_NABIL " 
sleep 4;
echo " SUPPORTED BY  >>>> MOHAMMED_ELSAFTY  " 
sleep 4;                                                                                                                  
echo "**********************************************************************************"
cd /tmp
set -e 
wget "https://raw.githubusercontent.com/emilnabil/neoboot_v9.58/main/enigma2-plugin-extensions-neoboot_$VERSION-r3-reboot_all.ipk"
wait
opkg install enigma2-plugin-extensions-neoboot_$VERSION-r3-reboot_all.ipk
cd ..
set +e
rm -f /tmp/enigma2-plugin-extensions-neoboot_$VERSION-r02_all-restart-GUI.ipk

#########################
cd $PLUGINPATH
chmod 755 ./bin/*
chmod 755 ./ex_init.py
chmod 755 ./files/*.sh
chmod -R +x ./ubi_reader_arm/*
chmod -R +x ./ubi_reader_mips/*

#########################
echo ""
echo "***********************************************************************"
echo $MY_EM                                                     
echo "**                       NeoBoot  : $VERSION                          *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ". >>>>         RESTARING     <<<<"
echo ""
if [ $OS = 'DreamOS' ]; then
    systemctl restart enigma2
else
    init 6
fi
exit 0






