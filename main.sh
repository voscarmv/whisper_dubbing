#!/bin/bash

# espeak -mp 0 -v es-la "`cat example2.ssml`"
espeak -mp 0 -w out.wav -v en "`cat example3.ssml`"
whisper-cli -m ~/git/whisper.cpp/models/ggml-medium.bin -l es -f out.wav -oj -osrt
node index.js > output.csv
# Make the dubbing fit the SRT durations to later paste them all in sequence
CTR=0;
DURSEC=`soxi -D out.wav`
sox -n  -b 16 -r 22050 -e signed-integer --channels 1 silence.wav trim 0.0 $DURSEC
cat output.csv | while IFS='|' read START END DURATION TEXT ; do
    FILENAME="f$CTR.wav"
    espeak -mp 0 -w $FILENAME -v es-la "$TEXT"
    DUR=`soxi -D $FILENAME`
    echo create $FILENAME
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

    STARTSEC=`echo "scale=3;$START/1000" | bc`

    sox silence.wav before.wav trim 0.0 $STARTSEC
    sox silence.wav after.wav trim `echo $STARTSEC+$DUR | bc`
    sox before.wav $FILENAME after.wav result.wav

    # sox  -m "|sox $FILENAME -p pad $STARTSEC" silence.wav -b 16 result.wav
    mv result.wav silence.wav
    echo '-----------------'
done

mv silence.wav dubbed.wav