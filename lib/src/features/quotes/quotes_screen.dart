import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/features/quotes/widgets/player_widget.dart';
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
              child: PlayerWidget(audioPlayer: audioPlayer)),
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
