#!/usr/bin/env bash

# Created by Jugal Kishore -- 2020
# Kernel Automated Script

function SET_ENVIRONMENT() {
    CC="${CLANG}"
    CLANG_VERSION="$(${CLANG} --version | grep 'clang version' | cut -c 37-)"
    git clone --depth=1 https://github.com/crazyuploader/AnyKernel3.git "${TOOLCHAIN}"/anykernel
    echo ""
    if [[ -z "${1}" ]]; then
        DEF_CONFIG="whyred_defconfig"
    else
        DEF_CONFIG="${1}"
    fi
}

# Variables Check
echo ""
if [[ -z ${TOOLCHAIN} ]]; then
    echo "Don't know where to get compilers from"
    exit 1
fi

if [[ -z "${KERNEL_NAME}" ]]; then
    echo "'KERNEL_NAME' variable not found, using default 'Kernel'"
    echo ""
    KERNEL_NAME="Daath"
fi

# Set Up Environment
SET_ENVIRONMENT "${1}"

# Variables
PWD="$(pwd)"
NAME="$(basename "${PWD}")"
TIME="$(date +%d%m%y)"
KERNEL_VERSION="$(make kernelversion)"

# Exporting Few Stuff
export ZIPNAME="${KERNEL_NAME}_${TIME}.zip"
export KERNEL_VERSION="${KERNEL_VERSION}"
export ANYKERNEL_DIR="${TOOLCHAIN}/anykernel"
export GCC_DIR="${GCC}"
export GCC32_DIR="${GCC32}"
export KBUILD_BUILD_USER="crazyuploader"
export KBUILD_BUILD_HOST="github.com"
export CC="${CC}"
export KBUILD_COMPILER_STRING="${CLANG_VERSION}"
export ARCH="arm64"
export SUBARCH="arm64"

# Telegram Message
echo ""
curl -s -X POST https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendMessage \
        -d text="CI Build -- ${NAME} at Version: ${KERNEL_VERSION}"         \
        -d chat_id="${KERNEL_CHAT_ID}"                                       \
        -d parse_mode=HTML
START="$(date +"%s")"
echo ""
echo "Compiling ${NAME} at version: ${KERNEL_VERSION} with Clang Version: ${CLANG_VERSION}"

# Compilation
echo ""
make O=out ARCH=arm64 "${DEF_CONFIG}"
make -j"$(nproc --all)"                                                     \
        O=out ARCH=arm64                                                     \
        CC="${CC}"                                                            \
        CLANG_TRIPLE="aarch64-linux-gnu-"                                      \
        CROSS_COMPILE="${GCC_DIR}"                                              \
        CROSS_COMPILE_ARM32="${GCC32_DIR}" | tee -a log.txt

# Time Difference
END="$(date +"%s")"
DIFF="$((END - START))"

# Zipping
echo ""
if [[ -f "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" ]]; then
  	cp "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL_DIR}"
  	cd "${ANYKERNEL_DIR}" || exit
  	zip -r9 "${ZIPNAME}" ./*
  	echo "Build Finished in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
	curl -F chat_id="${KERNEL_CHAT_ID}" \
         -F document=@"$(pwd)/${ZIPNAME}" \
         https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendDocument
    rm -rf "${ZIPNAME}" Image.gz-dtb
else
    curl -F chat_id="${KERNEL_CHAT_ID}" \
         -F caption="${NAME} finished with errors...\nAttaching Logs" \
         -F document=@"${PWD}/log.txt" \
         https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendDocument
    echo "Built with errors! Time Taken: $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
    exit 1
fi
rm -rf "${PWD}"/log.txt
