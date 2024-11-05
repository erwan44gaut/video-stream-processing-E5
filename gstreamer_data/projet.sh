OUTPUT_FILE="output"

PIPELINE_FIRST="    avfvideosrc capture-screen=true capture-screen-cursor=true capture-screen-mouse-clicks=true ! \
                    videoscale ! videoconvert ! video/x-raw,width=800,height=600 ! videorate ! "video/x-raw,framerate=5/1" ! \
                    timeoverlay halignment=center valignment=top ! tee name=t \
                        t. ! queue ! \
                            jpegenc ! rtpjpegpay ! udpsink host=127.0.0.1 port=5000 \
                        t. ! queue ! \
                            avimux ! filesink location=$OUTPUT_FILE.avi \
                        t. ! queue ! \
                            osxvideosink"

PIPELINE_SECOND="   udpsrc port=5000 ! application/x-rtp,media=video,clock-rate=90000,encoding-name=JPEG,payload=26 ! \
                    rtpjpegdepay ! jpegdec ! videoconvert ! autovideosink"

PIPELINE_THIRD="    filesrc location=output.avi ! decodebin name=demux \
                    demux. ! videoconvert ! autovideosink"

if [ "$1" = "1" ]; then
    gst-launch-1.0 $PIPELINE_FIRST
elif [ "$1" = "2" ]; then
    gst-launch-1.0 $PIPELINE_SECOND
elif [ "$1" = "3" ]; then
    gst-launch-1.0 $PIPELINE_THIRD
else
    echo "Usage: $0 [1|2|3]"
fi