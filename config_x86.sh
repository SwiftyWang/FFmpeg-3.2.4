CPU=x86
NDK=$HOME/Library/Android/sdk/android-ndk-r14b
SYSROOT=$NDK/platforms/android-16/arch-x86
TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64
EABIARCH=i686-linux-android
ADDITIONAL_CONFIGURE_FLAG="--disable-asm --cpu=cortex-a8"
CFLAGS="-m32"
CROSS_COMPILE=${TOOLCHAIN}/bin/${EABIARCH}-

PREFIX=$(pwd)/android-single/${CPU}
SONAME=libffmpeg.so
OUT_LIBRARY=${PREFIX}/${SONAME}