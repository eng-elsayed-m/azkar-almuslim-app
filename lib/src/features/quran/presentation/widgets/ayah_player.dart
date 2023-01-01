import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AyahPlayer extends StatefulWidget {
  final AssetsAudioPlayer audioPlayer;
  const AyahPlayer({super.key, required this.audioPlayer});
  @override
  State<AyahPlayer> createState() => _AyahPlayerState();
}

class _AyahPlayerState extends State<AyahPlayer> {
  @override
  Widget build(BuildContext context) {
    return PlayerBuilder.playerState(
      player: widget.audioPlayer,
      builder: (context, playerState) => Padding(
        padding: const EdgeInsets.all(3),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: StreamBuilder<Playing?>(
                    stream: widget.audioPlayer.current,
                    builder: (context, currentSnap) {
                      final current = currentSnap.data;
                      return currentSnap.hasData
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                current!.audio.audio.metas.title!,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "-",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            );
                    }),
              ),
              IconButton(
                icon: playerState == PlayerState.play
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: () async {
                  await widget.audioPlayer.playOrPause();
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
