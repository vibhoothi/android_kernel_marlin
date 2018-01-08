# Basic build script

# Export some vars $ stuff

KERNEL_DIR=$PWD
AK_DIR=$KERNEL_DIR/../AnyKernel2
TC_DIR=$KERNEL_DIR/../TC/aarch64-linux-android-4.9
DATE=$(date +"%Y%m%d")
VERSION="0.1"
KERNELNAME="Osmium"
DEVICENAME="sailfish"
KERNELFINAL=$KERNELNAME"_"$DEVICENAME"-"$VERSION"-"$DATE".zip"
ZIPFILE=$KERNEL_DIR/../$KERNELFINAL
export ARCH=arm64
export CROSS_COMPILE=/Volumes/buildbox/sailfish/kernel/TC/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TC_DIR/lib/
export KBUILD_OUTPUT=$KERNEL_DIR/../out

echo "zip: "$KERNELFINAL", AK: "$AK_DIR", TC: "$TC_DIR, ARCH: $ARCH, CC: 
$CROSS_COMPILE
sleep 1

# Fun starts here

make clean
make mrproper
make marlin_defconfig
if [ -f ../lastlog ]; then rm ../lastlog; fi
time make -j$(nproc) |& tee -a ../lastlog

if [ -f $KERNEL_DIR/../out/arch/arm64/boot/Image.gz-dtb ]
   then
	mv $KERNEL_DIR/../out/arch/arm64/boot/Image.gz-dtb $AK_DIR/zImage
	cd $AK_DIR

	zip -r9 $KERNELFINAL * -x *.zip $KERNELFINAL
	mv $KERNELFINAL ..
	cd $KERNEL_DIR
	make clean
	rm -rf ../out
        if [ -f ../lastlog ]; then rm ../lastlog; fi
	echo Output file: '$ZIPFILE' = $ZIPFILE
   else

	echo "Error occured, cannot find zImage, check logs for info"
fi
