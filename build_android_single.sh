#!/bin/bash
export TMPDIR=$(pwd)/ffmpegtemp #这句很重要，不然会报错 unable to create temporary file in
#引入配置文件
. config.sh

PREFIX=$(pwd)/android-single/$CPU

function build_one
{
    ./configure \
        --prefix=$PREFIX \
        --enable-neon \
        --enable-hwaccel=h264_vaapi \
        --enable-hwaccel=h264_dxva2 \
        --enable-hwaccel=mpeg4_vaapi \
        --enable-hwaccels \
        --enable-static \
        --enable-jni \
        --enable-mediacodec \
        --enable-asm \
        --disable-shared \
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
    make -j4
    make install

    $TOOLCHAIN/bin/arm-linux-androideabi-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
        libavcodec/libavcodec.a \
        libavfilter/libavfilter.a \
        libswresample/libswresample.a \
        libavformat/libavformat.a \
        libavutil/libavutil.a \
        libswscale/libswscale.a \
        -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
        $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a \

}

OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one
