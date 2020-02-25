#!/usr/bin/env bash

# Created by Jugal Kishore -- 2020
# Kernel Automated Script

function SET_ENVIRONMENT() {
    mkdir clang
    cd clang || exit
    wget -nv https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/clang-r377782b.tar.gz
    tar -xf clang-r377782b.tar.gz
    rm clang-r377782b.tar.gz
    CLANG_DIR="$(pwd)"
    CC="${CLANG_DIR}/bin/clang"
    CLANG_VERSION="$(./bin/clang --version | grep 'clang version' | cut -c 37-)"
    cd ..
    git clone --depth=1 https://github.com/crazyuploader/AnyKernel3.git anykernel
    git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 gcc
    git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 gcc32
}

if [[ -z "${REPO_URL}" ]]; then
    echo "'REPO_URL' variable not found, please set it first."
    exit 1
fi
if [[ -z "${DEF_CONFIG}" ]]; then
    echo "'DEF_CONFIG' variable not found, please set it first."
    exit 1
fi

git clone --depth=1 "${REPO_URL}" Kernel
cd Kernel || exit
SET_ENVIRONMENT
PWD="$(pwd)"
NAME="$(basename "${PWD}")"
TIME="$(date +%d%m%y%H%M)"
KERNEL_VERSION="$(make kernelversion)"
export ZIPNAME="${NAME}_Kernel-${TIME}.zip"
export KERNEL_VERSION="${KERNEL_VERSION}"
export ANYKERNEL_DIR="${PWD}/anykernel"
export GCC_DIR="${PWD}/gcc/bin/aarch64-linux-android-"
export GCC32_DIR="${PWD}/gcc32/bin/arm-linux-androideabi-"
export CC="${CC}"
export KBUILD_COMPILER_STRING="${CLANG_VERSION}"
export ARCH="arm64"
export SUBARCH="arm64"
curl -s -X POST https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendMessage -d text="CI Build -- ${NAME} at Version: ${KERNEL_VERSION}" -d chat_id="${KERNEL_CHAT_ID}" -d parse_mode=HTML
START="$(date +"%s")"
echo ""
echo "Compiling ${NAME} at version: ${KERNEL_VERSION}"
echo ""
make O=out ARCH=arm64 "${DEF_CONFIG}"
make -j"$(nproc --all)" O=out ARCH=arm64 CC="${CC}" CLANG_TRIPLE="aarch64-linux-gnu-" CROSS_COMPILE="${GCC_DIR}" CROSS_COMPILE_ARM32="${GCC32_DIR}"
END="$(date +"%s")"
DIFF="$((END - START))"
if [ -f "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" ]
	then
  	cp "$(pwd)/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL_DIR}"
  	cd "${ANYKERNEL_DIR}" || exit
  	zip -r9 "${ZIPNAME}" ./*
  	echo "Build Finished in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
	curl -F chat_id="${KERNEL_CHAT_ID}" -F document=@"$(pwd)/${ZIPNAME}" https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendDocument
else
  	curl -s -X POST https://api.telegram.org/bot"${BOT_API_TOKEN}"/sendMessage -d text="${NAME} Build finished with errors..." -d chat_id="${KERNEL_CHAT_ID}" -d parse_mode=HTML
    echo "Built with errors! Time Taken: $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)."
    exit 1
fi
