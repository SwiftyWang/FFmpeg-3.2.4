#!/bin/sh

#引入配置文件
. config.sh

PREFIX=$(pwd)/android/$CPU
ADDI_CFLAGS="-marm"
function build_android
{
    ./configure \
        #编译输出前缀
        --prefix=$PREFIX \
        #启动生成动态库
        --enable-shared \
        --disable-static \
        --disable-doc \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-ffserver \
        --disable-avdevice \
        --disable-doc \
        --disable-symver \
        --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
        --target-os=linux \
        --arch=arm \
        --enable-cross-compile \
        --sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
        --extra-ldflags="$ADDI_LDFLAGS" \
        $ADDITIONAL_CONFIGURE_FLAG
    make clean
    make
    make install
}

build_android