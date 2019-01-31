#!/usr/bin/env bash
# 1st parameter is zip name, default is kernel-<kernel_version>.zip
# change WORKING_PATH below to the path of kernel source directory
# change BUILD_PATH below to the path of kernel build (out) directory
# change ANYKERNEL_PATH below to the path of AnyKernel directory (https://github.com/osm0sis/AnyKernel2)
# change RELEASE_PATH below to the path of release (final anykernel + ramdisk zip) directory

set -e

WORKING_PATH=~/GitHub/android_kernel_xiaomi_msm8998
BUILD_PATH=~/Projects/builds/android_kernel_xiaomi_msm8998
ANYKERNEL_PATH=~/Projects/anykernel
RELEASE_PATH=~/Projects/releases

if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
	zip_name=$1
	kernel_version=$(make kernelversion)

	if [[ -z ${zip_name} ]]; then
		zip_name="kernel-${kernel_version}.zip"
	fi

	rm -f "$ANYKERNEL_PATH"/kernel*
	rm -f "$ANYKERNEL_PATH"/Image*

	cp "$BUILD_PATH"/arch/arm64/boot/Image.gz-dtb "$ANYKERNEL_PATH"/
	cd "$ANYKERNEL_PATH"

	zip -r9 "${zip_name}" * -x README.md "${zip_name}"

	mkdir -p "$RELEASE_PATH"/"${kernel_version}"
	mv -f "${zip_name}" "$RELEASE_PATH"/"$kernel_version"/
else
	echo "Please run this script from kernel source directory!"
fi
