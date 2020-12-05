#!/usr/bin/env bash

# Created by Jugal Kishore -- 2020
# Kernel Helper Script

# Variables
TOOLCHAIN="$(cd ../toolchains/ && pwd)"
ANYKERNEL="$(cd ../anykernel/ && pwd)"
PWD="$(pwd)"
NAME="$(basename "${PWD}")"
NO_OF_CORES="$(nproc --all)"
KERNEL_VERSION="$(make kernelversion)"
TIME="$(date +%d%m%y%H%M)"
CLANG_VERSION="$(cd ../toolchains/clang/bin/ && ./clang --version | grep 'clang version' | cut -c 37-)"

# Export Few Stuff
export KBUILD_BUILD_USER="crazyuploader"
export KBUILD_BUILD_HOST="github.com"
export ZIPNAME="${NAME}-${TIME}.zip"
export KBUILD_COMPILER_STRING="${CLANG_VERSION}"
export ARCH="arm64"
export SUBARCH="arm64"

# Colors
NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Clean up
echo "Cleaning Old Kernel Files"
rm -r "$(pwd)/out"
rm "${ANYKERNEL}/Image.gz-dtb"
echo "Done!"
sleep 0.2
clear

# Main Script
echo -e "${GREEN}###################################"
echo -e "${GREEN}###### KERNEL BUILDER HELPER ######"
echo -e "${GREEN}###################################${NC}"
echo ""
echo -e "Kernel Version: ${GREEN}$(make kernelversion)${NC}     \
Available Cores: ${GREEN}${NO_OF_CORES}${NC}     \
Current Branch: ${GREEN}$(git rev-parse --abbrev-ref HEAD)${NC}"
echo ""
echo -e "${YELLOW}Available Def_Configs - ${NC}"
echo ""
ls arch/arm64/configs/*whyred*
echo ""
echo "Enter Def_Config: "
read -r DEFCONFIG
echo ""
if [[ -f "arch/arm64/configs/${DEFCONFIG}" ]]; then
	echo -e "Entered Def_Config: ${GREEN}${DEFCONFIG}${NC}"
else
	echo -e "Entered Def_Config: ${RED}${DEFCONFIG} Does not exist.${NC}"
	exit 1
fi
echo ""
echo -e "Clang Version: ${GREEN}${CLANG_VERSION}${NC}"
echo ""
echo "Enter Number of Parallel Jobs:"
read -r CORES
if [[ ${CORES} -gt "${NO_OF_CORES}" ]]; then
	echo ""
	echo -e "Aho Ka! ${YELLOW}Using all ${NO_OF_CORES} cores${NC}"
	CORES="${NO_OF_CORES}"
else
	if [[ -z "${CORES}" || ${CORES} -lt "1" ]]; then
		echo -e "Aho Ka! ${YELLOW}Using all ${NO_OF_CORES} cores${NC}"
		CORES="${NO_OF_CORES}"
	fi
fi
echo ""
echo -e "Entered Number of Cores: ${GREEN}${CORES}${NC}"
echo ""
echo -e "Build Start Time: ${GREEN}$(date +"%T")${NC}"
echo ""
echo -e "${NAME} at Version: ${GREEN}${KERNEL_VERSION}${NC}"
echo ""
make O=out ARCH=arm64 "$DEFCONFIG"

# Compilation
START=$(date +"%s")
make -j"${CORES}" \
	O=out \
	ARCH=arm64 \
	CC="${TOOLCHAIN}/clang/bin/clang" \
	CLANG_TRIPLE="aarch64-linux-gnu-" \
	CROSS_COMPILE="${TOOLCHAIN}/gcc/bin/aarch64-linux-android-" \
	CROSS_COMPILE_ARM32="${TOOLCHAIN}/gcc32/bin/arm-linux-androideabi-"

# Time Difference
END=$(date +"%s")
DIFF=$((END - START))

# Zipping
if [[ -f $(pwd)/out/arch/arm64/boot/Image.gz-dtb ]]; then
	cp "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL}"
	cd "${ANYKERNEL}" || exit
	mv ./*.zip ../Builds
	zip -r9 "${ZIPNAME}" ./*
	ls -lh
	echo -e "${GREEN}Build Finished in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
	echo ""
	echo "Flashable Zip in: ${ANYKERNEL}"
	echo "MD5: $(md5sum "${ZIPNAME}")"
	rm -rf "${PWD}/out/"
	spd-say "Build Finished"
else
	echo ""
	echo -e "${RED}Build Finished with errors! Time Taken: $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
	rm -rf "${PWD}/out/"
	mplayer ~/beep.wav >>/dev/null 2>&1
	sleep 0.5
	spd-say "Build Failed with errors."
	mplayer ~/beep.wav >>/dev/null 2>&1
	exit 1
fi
