# Qubuntu
Qubuntu is a customized version of Ubuntu 20.04 with ROS Noetic and Quori packages preinstalled. These scripts are automatically built by a GitHub Action and posted to the releases page on GitHub. Alternatively, on most recent Debian OSes, this repository may be cloned and the OS built from scatch.

## Building
To build, run `./build.sh`. You will be prompted for your password during the build process. An ISO image will be produced.

## Installing

### Prerequisites
- 8 GB or larger USB Flash Drive

### Instructions
It is recommended to use [UNetBootin](https://unetbootin.github.io/) to write the ISO to a USB flash drive. Restart the Quori computer with the flash drive inserted, and hold F10 during boot to select the USB Flash Drive as the boot device.
