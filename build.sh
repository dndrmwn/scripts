#!/usr/bin/env bash
# 1st parameter is defconfig name, default is sagit_defconfig
# change WORKING_PATH below to the path of kernel source directory
# and BUILD_PATH below to the path of kernel build directory

set -e

WORKING_PATH=~/GitHub/android_kernel_xiaomi_msm8998
BUILD_PATH=~/Projects/builds/android_kernel_xiaomi_msm8998

if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
	defconfig=$1
	if [[ -z ${defconfig} ]]; then
		defconfig="sagit_defconfig"
	fi

	cd ../aarch64-linux-android-4.9
	export CROSS_COMPILE=$(pwd)/bin/aarch64-linux-android-
	export ARCH=arm64 && export SUBARCH=arm64
	cd ../android_kernel_xiaomi_msm8998
	make O="${BUILD_PATH}" clean
	make O="${BUILD_PATH}" mrproper
	make O="${BUILD_PATH}" "${defconfig}"
	make O="${BUILD_PATH}" -j$(nproc --all)
else
	echo "Please run this script from kernel source directory!"
fi
