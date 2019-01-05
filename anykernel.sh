#!/usr/bin/env bash
# 1st parameter is zip name, default is kernel-<kernel_version>.zip
# change WORKING_PATH below to the path of kernel source directory

set -e

WORKING_PATH=~/GitHub/android_kernel_xiaomi_msm8998

if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
	zip_name=$1
	kernel_version=$(make kernelversion)

	if [[ -z ${zip_name} ]]; then
		zip_name="kernel-${kernel_version}.zip"
	fi

	rm -f ~/Projects/anykernel/kernel*
	rm -f ~/Projects/anykernel/Image*
	cp ~/Projects/build/android_kernel_xiaomi_msm8998/arch/arm64/boot/Image.gz-dtb ~/Projects/anykernel/
	cd ~/Projects/anykernel
	zip -r9 "${zip_name}" * -x README.md "${zip_name}"
	mkdir -p ~/Projects/releases/"${kernel_version}"
	mv -f "${zip_name}" ~/Projects/releases/"$kernel_version"/
else
	echo "Please run this script from kernel source directory!"
fi
