#!/bin/bash
. config_arm.sh
export TMPDIR=$(pwd)/ffmpegtemp

PREFIX=$(pwd)/android-one/$CPU
ADDI_CFLAGS="-marm"
function build_one
{
	./configure \
	--prefix=$PREFIX \
	--enable-shared \
	--disable-static \
	--disable-doc \
	--disable-ffmpeg \
	--disable-ffplay \
	--disable-ffprobe \
	--disable-ffserver \
	--disable-doc \
	--disable-symver \
	--enable-small \
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
build_one