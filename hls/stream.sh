#!/bin/sh
# for Linux

#export GST_DEBUG=4

DATA_DIR="/root/hls/web/data"

ts_input="udpsrc uri=udp://$SRC_UDP buffer-size=512000 multicast-iface=$MCAST_IFACE ! video/mpegts"
demux="tsdemux"

video="queue max-size-buffers=0 max-size-time=0 ! h264parse"
video_dec="queue max-size-buffers=0 max-size-time=0 ! h264parse ! avdec_h264 ! videoscale ! video/x-raw, width=1280,height=720  ! videoconvert"
video_encode="x264enc tune=zerolatency bitrate=1568 speed-preset=3"
#video_encode="vaapih264enc"

audio1="queue max-size-buffers=0 max-size-time=0 ! ac3parse"
audio1_dec="queue max-size-buffers=0 max-size-time=0 ! ac3parse ! a52dec ! audioresample ! audioconvert ! audio/x-raw,channels=2 ! queue"
#audio1_dec="queue max-size-buffers=0 max-size-time=0 ! audio/x-private-ts-lpcm,rate=(int)48000,width=(int)16,channels=(int)2,channel-mask=(int)0x3 ! dvdlpcmdec ! audioresample ! audioconvert ! audio/x-raw,channels=2 ! queue"
audio1_encode="avenc_aac bitrate=128000"

tsmux="mpegtsmux"

hlssink2="hlssink2 playlist-root=$ROOT_URL/data location=$DATA_DIR/segment_%05d.ts max-files=5"

hlssink="hlssink playlist-root=$ROOT_URL/data location=$DATA_DIR/segment_%05d.ts max-files=5 target-duration=5"

mkdir -p $DATA_DIR || true
rm -rf $DATA_DIR/*.ts || true
rm playlist.m3u8

gst-launch-1.0 $tsmux name=mux0 ! $hlssink \
               $ts_input ! $demux  name=demux0 ! \
               $video_dec ! $video_encode ! mux0. \
               demux0. ! $audio1_dec ! $audio1_encode ! mux0.

# Video only
#gst-launch-1.0 $tsmux name=mux0 ! $hlssink \
#               $ts_input ! $demux  name=demux0 ! \
#               $video ! mux0. \
#               demux0. ! $audio_dec ! mux0.

# decodebin attempt
#gst-launch-1.0 $tsmux name=mux0 ! $hlssink \
#               $ts_input ! $decode ! decodebin name=decode0 ! \
#               $video_encode ! mux0. \
#               decode0. ! $audio1_encode ! mux0.
