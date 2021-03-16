#!/bin/sh
# for Linux

#gst-launch-1.0 \
#        v4l2src device=/dev/video0 \
#        ! videoconvert ! videoscale ! video/x-raw,width=320,height=240 \
#        ! clockoverlay shaded-background=true font-desc="Sans 38" \
#        ! theoraenc ! oggmux ! tcpserversink host=127.0.0.1 port=8080

gst-launch-1.0 rtspsrc location="rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov" ! \
        rtph264depay ! mpegtsmux ! \
        hlssink playlist-root=http://192.168.221.66:8080 location=/root/hls/segment_%05d.ts target-duration=5 max-files=5
        
echo "Stopped"
