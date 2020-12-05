#!/usr/bin/env bash

# Created by Jugal Kishore -- 2020
# Kernel Automated Script

function SET_ENVIRONMENT() {
    CC="${CLANG}"
    CLANG_VERSION="$(${CLANG} --version | grep 'clang version' | cut -c 37-)"
    if [[ ! -d "${TOOLCHAIN}/anykernel" ]]; then
        echo "Getting Anykernel3..."
        git clone --depth=1 https://github.com/crazyuploader/AnyKernel3.git "${TOOLCHAIN}"/anykernel 1> /dev/null
    fi
    if [[ -z "${1}" ]]; then
        DEF_CONFIG="whyred_defconfig"
    else
        DEF_CONFIG="${1}"
    fi
}

function SEND_FILE() {
    if [[ -z "${1}" ]]; then
        echo "Can't operate without a file!"
    fi
    ffsend upload --downloads 1 --expiry-time 24h "${1}"
}

# Variables Check
echo ""
if [[ -z "${TOOLCHAIN}" ]]; then
    echo "FATAL: Compilers not found"
    exit 1
fi

if [[ -z "${KERNEL_NAME}" ]]; then
    echo "Warning: 'KERNEL_NAME' variable not found, using default 'Daath' as kernel name"
    KERNEL_NAME="Daath"
fi

if [[ -z "${BOT_API_TOKEN}" ]]; then
    echo "Warning: Telegram Bot API Token not found..."
fi

if [[ -z "${KERNEL_CHAT_ID}" ]]; then
    echo "Warning: Telegram Chat ID not found..."
fi
echo ""

# Set Up Environment
SET_ENVIRONMENT "${1}"

# Variables
PWD="$(pwd)"
DIRNAME="$(basename "${PWD}")"
TIME="$(date +%d%m%y)"
KERNEL_VERSION="$(make kernelversion)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

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
# echo ""
# curl --silent --fail \
#         -X POST https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendMessage \
#         -d text="CI Build -- ${DIRNAME} at Version: ${KERNEL_VERSION}"         \
#         -d chat_id="${KERNEL_CHAT_ID}"                                       \
#         -d parse_mode=HTML

START="$(date +"%s")"
echo ""
echo "Compiling ${DIRNAME} at version: ${KERNEL_VERSION}"
echo "Defconfig: ${DEF_CONFIG}"
echo "Clang Version: ${CLANG_VERSION}"

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
    curl --silent --fail \
         -F chat_id="${KERNEL_CHAT_ID}" \
         -F caption="${KERNEL_NAME} at Version: ${KERNEL_VERSION} -- DEFCONFIG: ${DEF_CONFIG} -- BRANCH: ${BRANCH}" \
         -F document=@"$(pwd)/${ZIPNAME}" \
         https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendDocument
    EXIT_CODE="${?}"
    if [[ "${EXIT_CODE}" -ne "0" ]]; then
        echo "Sending zip failed using curl, trying ffsend"
        SEND_FILE "$(pwd)"/"${ZIPNAME}"
    fi
    rm -rf "${ZIPNAME}" Image.gz-dtb
else
    curl --silent \
         -F chat_id="${KERNEL_CHAT_ID}" \
         -F caption="${KERNEL_NAME} finished with errors... Attaching Logs" \
         -F document=@"${PWD}/log.txt" \
         https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendDocument
    echo "Built with errors! Time Taken: $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
    exit 1
fi
rm -rf "${PWD}"/log.txt
