const srt = require('./out.wav.json');

for(let i = 0; i < srt.transcription.length; i++){
    const start = srt.transcription[i].offsets.from;
    const end = srt.transcription[i].offsets.to;
    const duration = end - start;
    const text = srt.transcription[i].text;
    console.log(`${start}|${end}|${duration}|${text}`);
}
// console.log(srt.transcription);