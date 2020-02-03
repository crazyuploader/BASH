#!/usr/bin/env bash

# Colors
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

# Clean up
echo "Cleaning Old Kernel Files"
rm "$(pwd)/anykernel/Image.gz-dtb" "$(pwd)/anykernel/*.zip"
rm -r "$(pwd)/out"
echo "Done!"
sleep 1.5
clear

# Export Few Stuff
export KBUILD_BUILD_USER=crazyuploader
export KBUILD_BUILD_HOST=github
export KBUILD_JOBS="$(($(grep -c '^processor' /proc/cpuinfo) * 2))"
export ZIPNAME="KUNNEL.zip"
export KBUILD_COMPILER_STRING="Clang Version 9.0.3"
export ARCH=arm64 && export SUBARCH=arm64

# Main Script
echo -e "${GREEN}" "###################################"
echo -e "${GREEN}" "###### KERNEL BUILDER HELPER ######"
echo -e "${GREEN}" "###################################${NC}"
echo ""
echo -e "${YELLOW}" "Available Def_Configs - ${NC}"
echo ""
ls arch/arm64/configs/*whyred*
echo ""
echo "Enter Def_Config: "
read -r DEFCONFIG
TOOLCHAIN=$(cd ../toolchains/ && pwd)
echo ""
make O=out ARCH=arm64 "$DEFCONFIG"
START=$(date +"%s")
make -j"$(nproc --all)" O=out ARCH=arm64 CC="${TOOLCHAIN}/clang/clang-r353983c/bin/clang" CLANG_TRIPLE="aarch64-linux-gnu-" CROSS_COMPILE="${TOOLCHAIN}/gcc/bin/aarch64-linux-android-" CROSS_COMPILE_ARM32="${TOOLCHAIN}/gcc32/bin/arm-linux-androideabi-"
END=$(date +"%s")
DIFF=$((END - START))
if [[ -f $(pwd)/out/arch/arm64/boot/Image.gz-dtb ]]; then
    cp "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" "$(pwd)/anykernel"
    cd anykernel || exit
    zip -r9 "${ZIPNAME}" ./*
    ls -lh
    echo -e "${GREEN}" "Build Finished in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
else
    echo ""
    echo -e "${RED}" "Build Finished with errors!"
    exit 1
fi
