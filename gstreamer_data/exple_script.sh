#!/bin/sh
# =======================================================
#  author     : P. FOUBERT
#  date       : 09/01/2019
#  description: exemple d'utilisation d'un script
# =======================================================

rm -r dot/*
rm output.mp4
rm dot_view.png

DATA_FILM="The_Flying_Deuces_512kb.mp4"
SRT_FILM_FR="The.Flying.Deuces.French.srt"
SRT_FILM_ES="The.Flying.Deuces.Spanish.srt"
OUTPUT_FILM="output.mp4"

BIN_FILM="filesrc location=$DATA_FILM ! decodebin name=demux"

BIN_SS_TITRE_FR="filesrc location=$SRT_FILM_FR ! subparse"
BIN_SS_TITRE_ES="filesrc location=$SRT_FILM_ES ! subparse"

# BIN_RECORDER="tee_es. ! queue ! videoconvert ! x264enc ! mp4mux ! filesink location=$OUTPUT_FILM"

PIPELINE="  $BIN_FILM \
            demux. ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! \
            textoverlay name=txt_fr shaded-background=true valignment=top font-desc=\"Sans 20\" color=0xFF0000FF ! \
            textoverlay name=txt_es shaded-background=true valignment=bottom font-desc=\"Sans 20\" color=0xFFFABD00 ! \
            videorate ! video/x-raw,framerate=50/1 ! \
            autovideosink \
            $BIN_SS_TITRE_FR ! txt_fr. \
            $BIN_SS_TITRE_ES ! txt_es."
            # $BIN_RECORDER

export GST_DEBUG_DUMP_DOT_DIR="dot"
export GST_DEBUG=3
gst-launch-1.0 $PIPELINE

dot dot/*PAUSED_PLAYING.dot -Tpng > demo.png