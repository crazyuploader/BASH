#!/usr/bin/env bash

TOOLCHAIN=$(cd ../toolchains/ && pwd)
ANYKERNEL=$(cd ../anykernel/ && pwd)
PWD="$(pwd)"
NAME="$(basename "${PWD}")"
KERNEL_VERSION="$(make kernelversion)"

# Export Few Stuff
export KBUILD_BUILD_USER="crazyuploader"
export KBUILD_BUILD_HOST="github.com"
export KBUILD_JOBS="$(($(grep -c '^processor' /proc/cpuinfo) * 2))"
export ZIPNAME="${NAME}_KUNNEL.zip"
export KBUILD_COMPILER_STRING="Clang Version 9.0.3"
export ARCH="arm64"
export SUBARCH="arm64"

# Colors
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

# Clean up
echo "Cleaning Old Kernel Files"
rm -r "$(pwd)/out"
rm "${ANYKERNEL}/Image.gz-dtb"
echo "Done!"
sleep 1.5
clear

# Main Script
echo -e "${GREEN}###################################"
echo -e "${GREEN}###### KERNEL BUILDER HELPER ######"
echo -e "${GREEN}###################################${NC}"
echo ""
echo -e "Kernel Version: ${GREEN}$(make kernelversion)${NC}"
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
echo -e "Building ${NAME} at Version: ${GREEN}${KERNEL_VERSION}${NC}"
echo ""
make O=out ARCH=arm64 "$DEFCONFIG"
START=$(date +"%s")
make -j"$(nproc --all)" O=out ARCH=arm64 CC="${TOOLCHAIN}/clang/clang-r353983c/bin/clang" CLANG_TRIPLE="aarch64-linux-gnu-" CROSS_COMPILE="${TOOLCHAIN}/gcc/bin/aarch64-linux-android-" CROSS_COMPILE_ARM32="${TOOLCHAIN}/gcc32/bin/arm-linux-androideabi-"
END=$(date +"%s")
DIFF=$((END - START))
if [[ -f $(pwd)/out/arch/arm64/boot/Image.gz-dtb ]]; then
    cp "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL}"
    cd "${ANYKERNEL}" || exit
    rm -r ./*.zip
    zip -r9 "${ZIPNAME}" ./*
    ls -lh
    echo -e "${GREEN}Build Finished in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
    echo ""
    echo "Flashable Zip in: ${ANYKERNEL}"
    echo "MD5: $(md5sum "${ZIPNAME}")"
else
    echo ""
    echo -e "${RED}Build Finished with errors! Time Taken: $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s).${NC}"
    exit 1
fi
cd "${PWD}" || exit
rm -rf out/
