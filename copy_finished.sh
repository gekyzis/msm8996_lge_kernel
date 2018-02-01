#!/bin/bash
#
# This script copies the dtb-embedded kernel, and modules, to the *out* directory, in
# it's own appropriate subfolder.
# You can simply run ./copy_finished.sh after doing ./build.sh - it knows which device you built for.

RDIR=$(pwd)

ABORT() {
	echo "Error: $*"
	exit 1
}

DEVICE=$(cat "$RDIR/build/DEVICE") \
		|| ABORT "No device file found in *build* folder"

DEVICE_FOLDER=out/$DEVICE

SETUP_FOLDER() {
	echo "Creating folders..."
	mkdir -p $DEVICE_FOLDER/modules \
		|| ABORT "Failed to create folders"
}

COPY_KERNEL() {
	echo "Copying kernel and modules..."
	find build/lib/ -name '*.ko' -exec cp {} $DEVICE_FOLDER/modules \; \
		|| ABORT "Failed to copy modules"
	cp build/arch/arm64/boot/Image.lz4-dtb $DEVICE_FOLDER \
		|| ABORT "Failed to copy kernel"
}

cd "$RDIR" || ABORT "Failed to enter $RDIR!"

SETUP_FOLDER &&
COPY_KERNEL &&
echo "Finished copying $DEVICE kernel and modules to *out* folder"
