CPU=armv7-a
NDK=$HOME/Library/Android/sdk/android-ndk-r14b
SYSROOT=$NDK/platforms/android-16/arch-arm
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
EABIARCH=arm-linux-androideabi
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
CROSS_COMPILE=${TOOLCHAIN}/bin/${EABIARCH}-

PREFIX=$(pwd)/android-single/${CPU}
SONAME=libffmpeg-neon.so
OUT_LIBRARY=${PREFIX}/${SONAME}
