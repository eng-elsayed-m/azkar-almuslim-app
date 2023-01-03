import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final AssetsAudioPlayer audioPlayer;
  const PlayerWidget({super.key, required this.audioPlayer});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return PlayerBuilder.playerState(
      player: widget.audioPlayer,
      builder: (context, playerState) => Material(
        elevation: 6,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<Playing?>(
                  stream: widget.audioPlayer.current,
                  builder: (context, currentSnap) {
                    final current = currentSnap.data;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.audioPlayer.getCurrentAudioAlbum),
                        currentSnap.hasData
                            ? Text(current!.audio.audio.metas.title ?? '')
                            : const Text('-'),
                        const Spacer(),
                        StreamBuilder<Duration>(
                            stream: widget.audioPlayer.currentPosition,
                            builder: (context, positionSnap) {
                              Duration? duration = positionSnap.data;
                              return Row(
                                children: [
                                  positionSnap.hasData
                                      ? Text(
                                          duration!.toString().split(".").first)
                                      : const Text('00:00'),
                                  const Text(" / "),
                                  currentSnap.hasData
                                      ? Text(current!.audio.duration
                                          .toString()
                                          .split(".")
                                          .first)
                                      : const Text('00:00')
                                ],
                              );
                            }),
                      ],
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.green,
                    onPressed:
                        widget.audioPlayer.currentLoopMode == LoopMode.single
                            ? null
                            : () async {
                                if (widget.audioPlayer.currentLoopMode ==
                                    LoopMode.playlist) {
                                  await widget.audioPlayer.previous();
                                }
                              },
                  ),
                  IconButton(
                    icon: playerState == PlayerState.play
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    color: Colors.green,
                    onPressed: () async {
                      await widget.audioPlayer.playOrPause();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    color: Colors.green,
                    onPressed:
                        widget.audioPlayer.currentLoopMode == LoopMode.single
                            ? null
                            : () async {
                                if (widget.audioPlayer.currentLoopMode ==
                                    LoopMode.playlist) {
                                  await widget.audioPlayer.next();
                                }
                              },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop_circle_outlined),
                    color: playerState == PlayerState.stop
                        ? Colors.grey
                        : Colors.red,
                    onPressed: () async {
                      await widget.audioPlayer.stop();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
