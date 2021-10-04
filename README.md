# Qubuntu
Qubuntu is a customized version of Ubuntu 20.04 with ROS Noetic, Quori packages, and some additional utilities preinstalled.

## Building

Qubuntu's build procedure depends on the particulars of a Debian-family linux host. These steps have only been tested on Ubuntu 20.04, but it's likely any recent version of Debian or Ubuntu will work. If build fails open an issue with the particulars of your environment.

To build, run `./build.sh`. You will be prompted for your password during the build process. An ISO image will be produced.

## Installing

### Prerequisites
- 8 GB or larger USB Flash Drive

### Instructions
It is recommended to use [UNetBootin](https://unetbootin.github.io/) to write the ISO to a USB flash drive. Restart the Quori computer with the flash drive inserted, and hold F10 during boot to select the USB Flash Drive as the boot device. Proceed through the Ubuntu installation as normal; your preferred settings may be chosen.

## Post-installation Configuration 

Once Qubuntu is installed the following steps must be completed:

```sh
# Add ROS Noetic and Quori workspace to user's default environment
echo "source /opt/quori/setup.bash" >> ~/.bashrc

# Source in changes
. ~/.bashrc

# Make quori_embedded files writable (for calibration)
sudo chown -R $USER /opt/quori_embedded

# EXTERNAL STEP: Install microcontroller firmware (see quori_embedded repository)

# Configure udev rules for microcontrollers. Reboot when prompted.
sudo /opt/quori/devel/lib/quori_controller/init
```

All Quori functionality should now work.