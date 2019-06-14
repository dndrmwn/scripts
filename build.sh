#!/usr/bin/env bash
# 1st parameter is defconfig name, default is sagit_defconfig
# change WORKING_PATH below to the path of kernel source directory
# and BUILD_PATH below to the path of kernel build directory

set -e

WORKING_PATH=~/GitHub/Simplicity
BUILD_PATH=~/Projects/builds/Simplicity
CLANG_PATH=/home/ubuntu/GitHub/linux-x86/clang-r353983c
GCC_PATH=/home/ubuntu/GitHub/aarch64-linux-android-4.9
ARM_PATH=/home/ubuntu/GitHub/arm-linux-androideabi-4.9

if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
	defconfig=$1
	if [[ -z ${defconfig} ]]; then
		defconfig="sagit_defconfig"
	fi
	
	export KBUILD_COMPILER_STRING=$(${CLANG_PATH}/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
	make O="${BUILD_PATH}" clean
	make O="${BUILD_PATH}" mrproper
	make O="${BUILD_PATH}" ARCH=arm64 "${defconfig}"
	
	PATH="${CLANG_PATH}/bin:${GCC_PATH}/bin:${ARM_PATH}/bin:${PATH}"
	make -j$(nproc --all) O="${BUILD_PATH}" \
					ARCH=arm64 \
					CC=clang \
					CLANG_TRIPLE=aarch64-linux-gnu- \
					CROSS_COMPILE=aarch64-linux-android- \
					CROSS_COMPILE_ARM32=arm-linux-androideabi-
else
	echo "Please run this script from kernel source directory!"
fi
