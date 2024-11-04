DATA_FILM="The_Flying_Deuces_512kb.mp4"
SRT_FILM_FR="The.Flying.Deuces.French.srt"
PORT_STREAMING="1234"

BIN_FILM="filesrc location=$DATA_FILM ! decodebin name=demux"
BIN_SS_TITRE_FR="filesrc location=$SRT_FILM_FR ! subparse"

PIPELINE_SEND="$BIN_FILM \
                demux. ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! \
                videorate ! video/x-raw,framerate=50/1 ! \
                textoverlay name=txt_fr shaded-background=true ! tee name=t \
                    t. ! queue ! \
                        textoverlay text='flux sortant' shaded-background=true valignment=top ! \
                        autovideosink sync=false \
                    t. ! queue ! x264enc tune=zerolatency ! rtph264pay ! udpsink host=127.0.0.1 port=$PORT_STREAMING \
                $BIN_SS_TITRE_FR ! txt_fr."

PIPELINE_RECEIVE="  udpsrc port=$PORT_STREAMING ! application/x-rtp,payload=127 ! rtph264depay ! avdec_h264 ! videoconvert ! \
                    textoverlay text='flux entrant' shaded-background=true valignment=top ! autovideosink"

#check if arguement is passed to the script equal "s" or "r"
if [ "$1" = "s" ]; then
    gst-launch-1.0 $PIPELINE_SEND
elif [ "$1" = "r" ]; then
    gst-launch-1.0 $PIPELINE_RECEIVE
else
    echo "Utilisez 's' pour envoyer ou 'r' pour recevoir."
    exit 1
fi