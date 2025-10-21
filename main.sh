#!/bin/bash

# espeak -mp 0 -v es-la "`cat example2.ssml`"
espeak -mp 0 -w out.wav -v es-la "`cat example.ssml`"
whisper-cli -m ~/git/whisper.cpp/models/ggml-small.bin -l es -f out.wav -oj -osrt
node index.js > output.csv
# Make the dubbing fit the SRT durations to later paste them all in sequence
CTR=0;
cat output.csv | while IFS='|' read START END DURATION TEXT ; do
    espeak -mp 0 -w "f$CTR.wav" -v es-la "$TEXT"
    DUR=`soxi -D "f$CTR.wav"`
    echo create f$CTR.wav
    DUR1=`echo "scale=0; ($DUR*1000)/1" | bc`
    echo wav duarion $DUR1
    echo compare to SRT $DURATION
    SCALE=`echo "scale=2;100*($DUR1 / (0.8 * $DURATION))" | bc | sed 's/\..*//'`
    echo $SCALE

    echo '########'

    espeak -mp 0 -w "f$CTR.wav" -v es-la "<prosody rate=\"$SCALE%\">$TEXT</prosody>"
    DUR=`soxi -D "f$CTR.wav"`
    echo create f$CTR.wav
    DUR1=`echo "scale=0; ($DUR*1000)/1" | bc`
    echo wav duarion $DUR1
    echo compare to SRT $DURATION
    SCALE=`echo "scale=2;100 * $DUR1 / $DURATION" | bc `
    echo $SCALE
    ((CTR++))

    echo '-----------------'
done