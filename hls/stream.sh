#!/bin/sh
# for Linux

DATA_DIR="/root/hls/data"

ts_input="udpsrc uri=udp://$SRC_UDP buffer-size=512000 multicast-iface=$MCAST_IFACE ! video/mpegts"
demux="tsdemux"

video="queue max-size-buffers=0 max-size-time=0 ! h264parse"
video_dec="queue max-size-buffers=0 max-size-time=0 ! h264parse ! avdec_h264 ! videoscale ! video/x-raw, width=320,height=180  ! videoconvert"
video_encode="x264enc tune=zerolatency"

audio1="queue max-size-buffers=0 max-size-time=0 ! ac3parse"
audio1_dec="queue max-size-buffers=0 max-size-time=0 ! ac3parse ! a52dec ! audioresample ! audioconvert ! audio/x-raw,channels=2 ! queue"
audio1_encode="avenc_aac bitrate=128000"

tsmux="mpegtsmux"

hlssink="hlssink playlist-root=$ROOT_URL/data location=$DATA_DIR/segment_%05d.ts target-duration=5 max-files=5"

rm -rf $DATA_DIR || true
mkdir -p $DATA_DIR || true

gst-launch-1.0 $tsmux name=mux0 ! $hlssink \
               $ts_input ! $demux  name=demux0 ! \
               $video_dec ! $video_encode ! mux0. \
               demux0. ! $audio1_dec ! $audio1_encode ! mux0. 

#gst-launch-1.0 $tsmux name=mux0 ! $hlssink \
#               $ts_input ! $demux  name=demux0 ! \
#               $video ! mux0. \
#               demux0. ! $audio_dec ! mux0.                

