# machine-config

Start with Machine powered off. Plug in Ubuntu live USB and boot, press F12 to go into BIOS boot loader menu. Select Ubuntu live USB option.

Select try or install Ubuntu and do interactive install with extended selection of apps. Install 3rd party software for graphics and wifi hardware.
erase all, no encryption.

install finishes, reboot
remove usb and press enter

continue, don't share data

connect to wifi

sudo apt install -y git
git clone https://github.com/SetLordOfChaos/machine-config.git
cd machine-config
./bootstrap/ubuntu/bootstrap.sh