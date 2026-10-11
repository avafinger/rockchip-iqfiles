#!/bin/bash

v4l2-ctl -d /dev/v4l-subdev2 -c horizontal_flip=1,vertical_flip=1
media-ctl -d /dev/media1 --set-v4l2 '"rkisp-isp-subdev":0[fmt:SBGGR10_1X10/4608x2592]'
