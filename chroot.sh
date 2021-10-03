#!/bin/bash

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

# To avoid locale issues and in order to import GPG keys
export HOME=/root
export LC_ALL=C

add-apt-repository universe
add-apt-repository multiverse
apt update
apt install -y curl git libglfw3-dev openssh-server net-tools

# Install ROS Noetic
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
apt update
apt install -y ros-noetic-desktop-full libxmlrpcpp-dev librosconsole-dev wget ros-noetic-catkin-virtualenv libuvc-dev portaudio19-dev libasound2-dev ros-noetic-joint-trajectory-controller ros-noetic-rosserial-python ros-noetic-joy ros-noetic-gmapping ros-noetic-slam-gmapping ros-noetic-move-base vim ros-noetic-audio-common ros-noetic-speech-recognition-msgs python3-pip ros-noetic-sound-play ros-noetic-rqt-joint-trajectory-controller
pip install pyusb pyaudio pixel_ring speechrecognition pysound

# Install Orbbec Astra SDK
wget -Nc http://dl.orbbec3d.com/dist/astra/v2.1.1/AstraSDK-v2.1.1-24f74b8b15-Ubuntu-x86_64.zip  -O /tmp/AstraSDK-v2.1.1-24f74b8b15-Ubuntu-x86_64.zip
cd /tmp
unzip AstraSDK-v2.1.1-24f74b8b15-Ubuntu-x86_64.zip
tar -xf AstraSDK-v2.1.1-24f74b8b15-20200426T014025Z-Ubuntu18.04-x86_64.tar.gz -C /opt
export ASTRA_ROOT=/opt/AstraSDK-v2.1.1-24f74b8b15-20200426T014025Z-Ubuntu18.04-x86_64

# Install USB 4 Mic Array Firmware Repo
git clone https://github.com/respeaker/usb_4_mic_array.git /opt/usb_4_mic_array

# Install latest Quori Repo
git clone --recurse-submodules https://github.com/semio-ai/quori_ros /opt/quori
cd /opt/quori
source /opt/ros/noetic/setup.sh
catkin_make
cd -

# Add quori_embedded
git clone --recurse-submodules https://github.com/semio-ai/quori_embedded /opt/quori_embedded

# Add Arduino IDE
wget https://downloads.arduino.cc/arduino-1.8.16-linux64.tar.xz -O /tmp/arduino-1.8.16-linux64.tar.xz
tar -xf /tmp/arduino-1.8.16-linux64.tar.xz -C /opt

# Add Teensyduino
wget https://www.pjrc.com/teensy/td_155/TeensyduinoInstall.linux64 -O /tmp/TeensyduinoInstall.linux64
chmod +x /tmp/TeensyduinoInstall.linux64
/tmp/TeensyduinoInstall.linux64 --dir=/opt/arduino-1.8.16

# Add Chromium (for Semio software)
snap install chromium

# Clean up
apt clean
rm -rf /tmp/* ~/.bash_history
rm /var/lib/dbus/machine-id


umount /proc
umount /sys
umount /dev/pts
