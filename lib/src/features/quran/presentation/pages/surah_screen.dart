import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/quran/data/models/surahs_model.dart';
import 'package:azkar/src/features/quran/domain/entities/surahs.dart';
import 'package:azkar/src/features/quran/presentation/bloc/surah/bloc.dart';
import 'package:azkar/src/features/quran/presentation/pages/editions_list.dart';
import 'package:azkar/src/features/quran/presentation/widgets/ayah_player.dart';
import 'package:azkar/src/injection_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String defaultTranslationEdition = "quran-uthmani";
String defaultAudioEdition = "ar.alafasy";

class SurahScreen extends StatefulWidget {
  final ReferencesEntity ref;
  const SurahScreen({super.key, required this.ref});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  AssetsAudioPlayer? audioPlayer;

  Future play(String url, String title) async {
    await audioPlayer!.open(
      Audio.network(url, metas: Metas(title: title)),
      loopMode: LoopMode.single,
      autoStart: true,
      showNotification: true,
      notificationSettings: const NotificationSettings(
          prevEnabled: true,
          nextEnabled: true,
          playPauseEnabled: true,
          seekBarEnabled: true,
          stopEnabled: true),
      playInBackground: PlayInBackground.disabledRestoreOnForeground,
    );
    await audioPlayer!.play();
    setState(() {});
  }

  String rType(String type) {
    return type == "Meccan" ? 'مكية' : "مدنية";
  }

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    audioPlayer = AssetsAudioPlayer.withId(widget.ref.number.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.ref.number}- ${widget.ref.name}  (${rType(widget.ref.revelationType!)})"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await audioPlayer!.dispose();
          return true;
        },
        child: BlocProvider<SurahBloc>(
          create: (context) => sl<SurahBloc>()
            ..add(GetSurahEvent(
                number: widget.ref.number!,
                audioEdition: defaultAudioEdition,
                translationEdition: defaultTranslationEdition)),
          child: BlocBuilder<SurahBloc, SurahState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/title-r.png",
                          height: dSize.height * 0.06,
                          color: const Color(0xFF0E7A6E),
                        ),
                        if (state is SurahLoadedState)
                          Text(
                            state.surah.translationData!.edition!.language ==
                                    "ar"
                                ? state.surah.mainData!.name.toString()
                                : state.surah.translationData!.englishName
                                    .toString(),
                            textScaleFactor: 1.3,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontFamily: "AmiriQuran"),
                          ),
                        Image.asset(
                          "assets/images/title-l.png",
                          height: dSize.height * 0.06,
                          color: const Color(0xFF0E7A6E),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: state is SurahLoadedState
                            ? RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                    children: state
                                        .surah.translationData!.ayahs!
                                        .map((ayah) => TextSpan(
                                              text:
                                                  "${ayah.text!} |${ayah.numberInSurah}| ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "AmiriQuran",
                                                  ),
                                              recognizer: TapGestureRecognizer(
                                                  debugOwner: state.surah
                                                      .mainData!.numberOfAyahs)
                                                ..onTap = () async {
                                                  print(ayah.numberInSurah);
                                                  final url = state
                                                      .surah.audioData!.ayahs!
                                                      .firstWhere((element) =>
                                                          element
                                                              .numberInSurah ==
                                                          ayah.numberInSurah);
                                                  print(url);
                                                  play(
                                                      url.audio!,
                                                      ayah.numberInSurah
                                                          .toString());
                                                },
                                            ))
                                        .toList()))
                            : const AppIndicator(),
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 1,
                              child: AyahPlayer(audioPlayer: audioPlayer!)),
                          Expanded(
                            flex: 4,
                            child: EditionsList(
                              number: widget.ref.number!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
