# Play N videos in sync

This is a toy app to try and understand how many videos I can play simultaneously on iOS. Some forums say it's 4. I seem to hit a limit at 16.

## Behaviours to try out:
- Can I quickly toggle between several videos within a same AVPlayerLayer, with random seekTimes?
- Can I sync video playback on an external clock (driven by the audio render callback, for instance)?

## Links
- [This guy also observes 16 vids as a max](https://stackoverflow.com/questions/40474480/how-many-avplayers-are-allowed-to-be-created-at-the-same-time)
- [The four streams limit seems to be unofficially admitted by Apple](https://stackoverflow.com/questions/8608570/avplayeritem-fails-with-avstatusfailed-and-error-code-cannot-decode/9933853#9933853)
- [Some dev hints from the Pinterest engineers](https://medium.com/@Pinterest_Engineering/building-native-video-pins-7ff89ad3ec33)
