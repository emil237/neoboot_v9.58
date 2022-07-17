#!/bin/bash
# ###############################################
# SCRIPT : DOWNLOAD AND INSTALL NEOBOOT
#
##command=wget https://raw.githubusercontent.com/emil237/neoboot_v9.58/main/installer.sh -O - | /bin/sh ############################################### ###########################################
versions="17.07.2022"
NEOBOOT='9.58'
###########################################
# Configure where we can find things here #
MY_EM="*****************************************************************************************************"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot'
REQUIRED='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot/files'
TOOLS='/usr/lib/enigma2/python/Tools'
PREDION='/usr/lib/periodon'
URL='https://raw.githubusercontent.com/emil237/plugins/main'
PYTHON_VERSION=$(python -c"import sys; print(sys.hexversion)")

###########################################
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

########################
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
if [ $PYTHON = "PY3" ]; then
    echo ":You have Python3 image ..."
    PLUGINPY32='NEOBOOT-PYTHON32.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY32:?}"
else
    echo ":You have Python2 image ..."
    PLUGINPY32='NEOBOOT-PYTHON32.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY32:?}"    
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
cd /tmp
set -e 
wget "https://raw.githubusercontent.com/emil237/neoboot_v9.58/main/neoboot_v9.58-r02_all.tar.gz"
wait
tar -xzf neoboot_v9.58-r02_all.tar.gz  -C /
wait
cd ..
set +e
rm -f /tmp/neoboot_v9.58-r02_all.tar.gz
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 4;                                                                                                                  
echo "**********************************************************************************"
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
init 4
sleep 2
init 3
exit 0









