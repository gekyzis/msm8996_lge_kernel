#!/bin/bash

RDIR=$(pwd)

ABORT() {
	[ "$1" ] && echo "Error: $*"
	exit 1
}

[ "$1" ] && DEVICE=$1
[ "$DEVICE" ]

DEVICE_FOLDER=out/${DEVICE}

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
