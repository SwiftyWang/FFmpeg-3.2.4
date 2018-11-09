#!/bin/bash
export TMPDIR=$(pwd)/ffmpegtemp #这句很重要，不然会报错 unable to create temporary file in

function build_one
{
    ./configure \
        --prefix=$PREFIX \
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
        --cross-prefix=${CROSS_COMPILE} \
        --target-os=linux \
        --arch=arm \
        --enable-cross-compile \
        --enable-small \
        --sysroot=${SYSROOT} \
        --extra-cflags="-Os -fpic ${CFLAGS}" \
        --extra-ldflags="-Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib  -nostdlib -lc -lm -ldl -llog -L$PREFIX/lib" \
        ${ADDITIONAL_CONFIGURE_FLAG}
    make clean
    make -j4
    make install

    ${CROSS_COMPILE}ld \
    -rpath-link=${SYSROOT}/usr/lib \
    -L${SYSROOT}/usr/lib \
    -L${PREFIX}/lib \
    -soname ${SONAME} \
    -shared -nostdlib -Bsymbolic --whole-archive --no-undefined \
    -o ${OUT_LIBRARY} \
    -lavcodec \
    -lavfilter \
    -lswresample \
    -lavformat \
    -lavutil \
    -lswscale \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    ${TOOLCHAIN}/lib/gcc/${EABIARCH}/4.9.x/libgcc.a \

}

echo "build arm start"
. config_arm.sh
build_one
echo "build arm end"

#echo "build x86 start"
#. config_x86.sh
#build_one
#echo "build x86 end"

