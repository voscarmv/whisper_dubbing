#!/bin/bash

espeak -mp 0 -w out.wav -v es-la '
    <speak>
    <prosody rate="slow">
        Hola, ¿cómo estás hoy?
    </prosody>
    <break time="1s">
    
    <prosody rate="medium">
        Quería contarte algo interesante que me pasó esta mañana.
    </prosody>
    <break time="3s">
    
    <prosody rate="fast">
        Iba caminando al trabajo cuando, de repente, empezó a llover muy fuerte.
    </prosody>
    <break time="1s">
    
    <prosody rate="slow">
        Así que me refugié bajo un árbol, esperando que pasara la tormenta.
    </prosody>
    <break time="2s">
    
    <prosody rate="x-fast">
        ¡Y justo entonces recordé que había dejado la ventana abierta!
    </prosody>
    </speak>
'
whisper-cli -m ~/git/whisper.cpp/models/ggml-small.bin -l es -f out.wav -oj