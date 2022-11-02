import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/features/quotes/widgets/quote_card.dart';
import 'package:flutter/material.dart';

class QuotesScreen extends StatefulWidget {
  final CategoryModel category;

  const QuotesScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final audioPlayer = AssetsAudioPlayer();

  Future play(int index) async {
    if (audioPlayer.currentLoopMode == LoopMode.playlist) {
      await audioPlayer.playlistPlayAtIndex(index);
    } else {
      await audioPlayer.open(
        Playlist(
            audios: widget.category.array!
                .map((e) => Audio("assets${e.audio}",
                    metas: Metas(
                        title: e.filename, album: widget.category.category!)))
                .toList()),
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings: const NotificationSettings(
            prevEnabled: true,
            nextEnabled: true,
            playPauseEnabled: true,
            seekBarEnabled: true,
            stopEnabled: true),
        playInBackground: PlayInBackground.enabled,
      );
      await audioPlayer.playlistPlayAtIndex(index);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialCat();
  }

  initialCat() async {
    await audioPlayer.open(
        Audio(
          'assets${widget.category.audio}',
          metas: Metas(title: widget.category.category, album: 'كاملة'),
        ),
        autoStart: true,
        playInBackground: PlayInBackground.disabledRestoreOnForeground);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        audioPlayer.dispose();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.category.category}',
              style: const TextStyle(
                  fontFamily: "A-Hemmat",
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: PlayerBuilder.playerState(
                player: audioPlayer,
                builder: (context, playerState) => Material(
                  elevation: 6,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.normalize(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<Playing?>(
                            stream: audioPlayer.current,
                            builder: (context, currentSnap) {
                              final current = currentSnap.data;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(audioPlayer.getCurrentAudioAlbum),
                                  currentSnap.hasData
                                      ? Text(
                                          "${current!.audio.audio.metas.title ?? ''}")
                                      : const Text('-'),
                                  Spacer(),
                                  StreamBuilder<Duration>(
                                      stream: audioPlayer.currentPosition,
                                      builder: (context, positionSnap) {
                                        Duration? duration = positionSnap.data;
                                        return Row(
                                          children: [
                                            positionSnap.hasData
                                                ? Text(duration!
                                                    .toString()
                                                    .split(".")
                                                    .first)
                                                : const Text('00:00'),
                                            Text(" / "),
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
                                  audioPlayer.currentLoopMode == LoopMode.single
                                      ? null
                                      : () async {
                                          if (audioPlayer.currentLoopMode ==
                                              LoopMode.playlist) {
                                            await audioPlayer.previous();
                                            setState(() {});
                                          }
                                        },
                            ),
                            IconButton(
                              icon: playerState == PlayerState.play
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                              color: Colors.green,
                              onPressed: () async {
                                await audioPlayer.playOrPause();
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              color: Colors.green,
                              onPressed:
                                  audioPlayer.currentLoopMode == LoopMode.single
                                      ? null
                                      : () async {
                                          if (audioPlayer.currentLoopMode ==
                                              LoopMode.playlist) {
                                            await audioPlayer.next();
                                            setState(() {});
                                          }
                                        },
                            ),
                            IconButton(
                              icon: const Icon(Icons.stop_circle_outlined),
                              color: playerState == PlayerState.stop
                                  ? Colors.grey
                                  : Colors.red,
                              onPressed: () async {
                                await audioPlayer.stop();
                                setState(() {});
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: widget.category.array!
              .map((element) => QuoteCard(
                    quote: element,
                    isPlaying:
                        audioPlayer.getCurrentAudioTitle == element.filename,
                    play: () async {
                      await play(widget.category.array!.indexWhere(
                          (selectedAudio) => element.id == selectedAudio.id));
                      setState(() {});
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}