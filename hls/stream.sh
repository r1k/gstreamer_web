#!/bin/sh
# for Linux

#gst-launch-1.0 \
#        v4l2src device=/dev/video0 \
#        ! videoconvert ! videoscale ! video/x-raw,width=320,height=240 \
#        ! clockoverlay shaded-background=true font-desc="Sans 38" \
#        ! theoraenc ! oggmux ! tcpserversink host=0.0.0.0 port=8080

gst-launch-1.0 filesrc location="BISS-CA-32Keysin3rdSrvc.ts" ! \
        hlssink playlist-root=http://rkmbpro16.local:8080 location=/root/hls/segment_%05d.ts target-duration=5 max-files=5
        
echo "Stopped"
