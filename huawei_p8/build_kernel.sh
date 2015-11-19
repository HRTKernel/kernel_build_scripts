#!/bin/bash
# kernel build script by thehacker911

KERNEL_DIR=$(pwd)
BUILD_USER="$USER"
TOOLCHAIN_DIR=/home/maik/android/toolchains #Hier der Pfad zu den Toolchains rein
BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`

# Toolchains

#Sabermod
#Linaro
BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/stock_aarch64/bin/aarch64-linux-android- # Hier der Toolchain rein der zum builden benutzt wird


#vars
KERNEL_DEFCONFIG=merge_hi3635_defconfig # Hier die Device Config rein
KERNEL_VER="Hacker-Kernel-Test" # Hier der Kernel Name rein


BUILD_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: MAKE CLEAN"
	echo "=============================================="
	echo ""
	

	make clean
	make ARCH=arm64 distclean
	rm -rf ../out
	find . -name "*.dtb" -exec rm {} \;

	echo ""
	echo "=============================================="
	echo "END: MAKE CLEAN"
	echo "=============================================="
	echo ""

	echo ""
	echo "=============================================="
	echo "START: BUILD_KERNEL"
	echo "=============================================="
	echo ""
	echo "$KERNEL_VER" 
	
	export LOCALVERSION=-`echo $KERNEL_VER`
        mkdir ../out
	export CROSS_COMPILE=$BUILD_CROSS_COMPILE
	make ARCH=arm64 O=../out merge_hi3635_defconfig
	make ARCH=arm64 O=../out -j$BUILD_JOB_NUMBER
	

	echo ""
	echo "================================="
	echo "END: BUILD_KERNEL"
	echo "================================="
	echo ""
}





# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`
	BUILD_DATE=`date +%m-%d-%Y`
	BUILD_KERNEL


	END_TIME=`date +%s`
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	 | tee -a ./build.log

# Credits:
# Samsung
# google
# osm0sis
# cyanogenmod
# kylon 
