import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AyahPlayer extends StatelessWidget {
  final AssetsAudioPlayer audioPlayer;
  final bool pinned;
  final void Function() pinning;
  const AyahPlayer(
      {super.key,
      required this.audioPlayer,
      this.pinned = false,
      required this.pinning});

  @override
  Widget build(BuildContext context) {
    return PlayerBuilder.playerState(
      player: audioPlayer,
      builder: (context, playerState) => Padding(
        padding: const EdgeInsets.all(3),
        child: Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () async {
                    await audioPlayer.playOrPause();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: playerState == PlayerState.play
                        ? const Icon(
                            Icons.pause,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.play_arrow,
                          ),
                  )),
              StreamBuilder<LoopMode>(
                  stream: audioPlayer.loopMode,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: () async {
                        if (!snapshot.hasData) return;
                        if (snapshot.data == LoopMode.none) {
                          await audioPlayer.setLoopMode(LoopMode.single);
                        } else {
                          await audioPlayer.setLoopMode(LoopMode.none);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: snapshot.data == LoopMode.none
                            ? const Icon(
                                Icons.repeat_one,
                                color: Colors.yellow,
                              )
                            : const Icon(
                                Icons.repeat,
                                color: Colors.green,
                              ),
                      ),
                    );
                  }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StreamBuilder<Playing?>(
                      stream: audioPlayer.current,
                      builder: (context, currentSnap) {
                        final current = currentSnap.data;
                        return currentSnap.hasData
                            ? Text(
                                current!.audio.audio.metas.title!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            : Text(
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? 'اضغط الاية للقرائة'
                                    : 'Tap Ayah to read',
                              );
                      }),
                ),
              ),
              InkWell(
                onTap: pinning,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: pinned
                      ? const Icon(
                          Icons.push_pin_rounded,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.push_pin_outlined,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
