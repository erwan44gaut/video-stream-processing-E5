gst-launch-1.0 \
    compositor name=comp \
    sink_0::xpos=0 sink_0::ypos=0 \
    sink_1::xpos=10 sink_1::ypos=10 \
    sink_2::xpos=0 sink_2::ypos=540 \
    sink_3::xpos=960 sink_3::ypos=10 \
    sink_4::xpos=960 sink_4::ypos=540 ! \
    videoconvert ! videoscale ! video/x-raw,framerate=60/1,width=1920,height=1080 ! glimagesink \
    videotestsrc pattern=snow ! videoscale ! video/x-raw,framerate=60/1,width=1920,height=1080 ! comp.sink_0 \
    videotestsrc pattern=circular ! videoscale ! video/x-raw,framerate=60/1,width=940,height=520 ! comp.sink_1 \
    videotestsrc pattern=smpte ! videoscale ! video/x-raw,framerate=60/1,width=940,height=520 ! comp.sink_2 \
    videotestsrc pattern=ball ! videoscale ! video/x-raw,framerate=60/1,width=940,height=520 ! comp.sink_3 \
    videotestsrc pattern=blink ! videoscale ! video/x-raw,framerate=60/1,width=940,height=520 ! comp.sink_4