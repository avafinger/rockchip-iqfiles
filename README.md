# rockchip-iqfiles
Basic iqfiles for some rpi cameras on Rockchip

## Introduction

These iqfiles are considered experimental, and in order to be useful you need to match AIQ server version / Kernel Version / ISP version or the 3A server will crash.
If you are a photographer or want to obtain better images, you can use the MANUALFOCUS version, where you set the exposure, analog gain, digital gain, and absolute focus to capture higher quality images.

| Family Board | Camera module | Frame size | File | Auto Focus | Kernel version | AIQ version | ISP version | Quality max ***** | Credits |
| :-----------------: | :-----------------: | :-----------------: | :-----------: | :------------ | :-----------: | :------------: | :--------------------: | :------------: | :-----------: |
| Rock 3 / Zero 3 | IMX708 | 4096x2592 | imx708_uhq_default_4096x2592.json_AUTOFOCUS | Auto | 5.10.160 | v5.0x1.2-rc2 | 2.2.1 | ** | Me, Myself and I |
| Rock 3 / Zero 3 | IMX708 | 4096x2592 |   imx708_uhq_default_4096x2592.json_MANUALFOCUS | Manual | 5.10.160 | v5.0x1.2-rc2 | 2.2.1 | *** | Me, Myself and I |
| Rock 5 | IMX708 | 4608x2592 | imx708_uhq_default_4608x2592.json | Auto | 6.1.43 | v6.0x6.1 | 2.4.0 | **** | Radxa |
| Rock 5 | IMX290 | 1920x1080 | imx290_imx290_default.json | no | 6.1.43 | v6.0x6.1 | 2.4.0 | *** | Me, Myself and I |




## Installation

The iqfiles are stored (usually) in the /etc/iqfiles directory and should follow your Rockchip name convention in your DTS, something like "drivername_modulename_lensname.json".

**Example on Zero 3W:**

Drop to a cmd line

Stop the camera engine

	  systemctl stop rkaiq_3A


Copy the file
  
    sudo cp -vfr imx708_uhq_default_4096x2592.json_MANUALFOCUS /etc/iqfiles/imx708_uhq_default.json


Start the engine to can additional output

	  sudo /usr/bin/rkaiq_3A_server


Start capturing frames and watch the output

If the 3A server crashes, you are not running the 3A server with the correct version, downgrade or upgrade it to the correct version, or you can tune the json file to your version.


## About the Auto Focus

In my tests here, autofocus is slow due to errors thrown by the algorithm with high resolutions, and sometimes it focuses on the wrong object. To fix this, I provided the iqfile with manual FOCUS.

**Available controls are:**

	focus_absolute -> [0, 1023] where [far, close]

Example:
	
	v4l2-ctl -d /dev/v4l-subdev1 -c focus_absolute=0
	v4l2-ctl -d /dev/v4l-subdev1 -c focus_absolute=447

Adjust the focus where you want it to focus increasing or decreasing the focus_absolute

## Image controls

You can control exposure and gains to have a clear and good image.

Example:
	
	v4l2-ctl -d /dev/v4l-subdev1 -c exposure=890
	v4l2-ctl -d /dev/v4l-subdev1 -c analogue_gain=800
	v4l2-ctl -d /dev/v4l-subdev1 -c digital_gain=214

and then focus on the object:

	v4l2-ctl -d /dev/v4l-subdev1 -c focus_absolute=447
	v4l2-ctl -d /dev/v4l-subdev1 -c focus_absolute=480
	v4l2-ctl -d /dev/v4l-subdev1 -c focus_absolute=511	

## Live capturing video and tuning manually using gstreamer

**Rock5 - Wayland**

* 1920x1080 Display monitor
  
		gst-launch-1.0 v4l2src device=/dev/video11 io-mode=dmabuf  do-timestamp=true ! video/x-raw,format=NV12,width=4608,height=2592,framerate=14/1 ! waylandsink render-rectangle='<0,0,1920,1080>' sync=false

* 3840x2160 Display monitor

		gst-launch-1.0 v4l2src device=/dev/video11 io-mode=dmabuf  do-timestamp=true ! video/x-raw,format=NV12,width=4608,height=2592,framerate=14/1 ! waylandsink render-rectangle='<0,0,3840,2160>' sync=false

**Rock3 - Wayland**

* 1920x1080 Display monitor
  
		gst-launch-1.0 v4l2src device=/dev/video11 io-mode=dmabuf  do-timestamp=true ! video/x-raw,format=NV12,width=4096,height=2592,framerate=14/1 ! waylandsink render-rectangle='<0,0,1920,1080>' sync=false

* 3840x2160 Display monitor

		gst-launch-1.0 v4l2src device=/dev/video11 io-mode=dmabuf  do-timestamp=true ! video/x-raw,format=NV12,width=4096,height=2592,framerate=14/1 ! waylandsink render-rectangle='<0,0,3840,2160>' sync=false
