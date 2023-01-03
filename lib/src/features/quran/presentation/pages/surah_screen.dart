import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/src/core/utils/configs/app_theme.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/quran/data/models/pin_model.dart';
import 'package:azkar/src/features/quran/data/models/surah_model.dart';
import 'package:azkar/src/features/quran/domain/entities/surahs.dart';
import 'package:azkar/src/features/quran/presentation/bloc/pin/bloc.dart';
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
  Ayahs? selectedAyah;
  Future play() async {
    await audioPlayer!.open(
      Audio.network(selectedAyah!.audio!,
          metas: Metas(title: selectedAyah!.text, extra: {
            "ayah": selectedAyah!.numberInSurah,
            "surah": widget.ref.number,
            "title": widget.ref.name,
          })),
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
            builder: (context, surahState) {
              return BlocProvider<PinBloc>(
                create: (context) => sl<PinBloc>()..add(GetPinEvent()),
                child: BlocBuilder<PinBloc, PinState>(
                  builder: (context, pinState) {
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
                              if (surahState is SurahLoadedState)
                                Text(
                                  surahState.surah.translationData!.edition!
                                              .language ==
                                          "ar"
                                      ? surahState.surah.mainData!.name
                                          .toString()
                                      : surahState
                                          .surah.translationData!.englishName
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
                              child: surahState is SurahLoadedState
                                  ? RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                          children:
                                              surahState
                                                  .surah.translationData!.ayahs!
                                                  .map((ayah) => TextSpan(
                                                        text:
                                                            "${ayah.text!} |${ayah.numberInSurah}| ",
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  backgroundColor: pinState
                                                                              is PinLoadedState &&
                                                                          pinState.pin !=
                                                                              null
                                                                      ? pinState.pin!.ayah == ayah.numberInSurah &&
                                                                              pinState.pin!.surah == widget.ref.number
                                                                          ? Colors.green.withOpacity(0.5)
                                                                          : Colors.transparent
                                                                      : null,
                                                                  fontFamily:
                                                                      "AmiriQuran",
                                                                ),
                                                        recognizer:
                                                            TapGestureRecognizer(
                                                                debugOwner:
                                                                    surahState
                                                                        .surah
                                                                        .mainData!
                                                                        .numberOfAyahs)
                                                              ..onTap =
                                                                  () async {
                                                                selectedAyah = surahState
                                                                    .surah
                                                                    .audioData!
                                                                    .ayahs!
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .numberInSurah ==
                                                                        ayah.numberInSurah);
                                                                play();
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                EditionsList(
                                  number: widget.ref.number!,
                                ),
                                AyahPlayer(
                                    pinning: () async {
                                      if (selectedAyah == null) {
                                        return;
                                      }
                                      if (pinState is PinLoadedState) {
                                        if (pinState.pin != null &&
                                            pinState.pin!.ayah ==
                                                selectedAyah!.numberInSurah &&
                                            widget.ref.number ==
                                                pinState.pin!.surah) {
                                          context
                                              .read<PinBloc>()
                                              .add(SetPinEvent(PinModel()));
                                        } else {
                                          context.read<PinBloc>().add(
                                              SetPinEvent(PinModel(
                                                  ayah: selectedAyah!
                                                      .numberInSurah,
                                                  surah: widget.ref.number,
                                                  title: widget.ref.name)));
                                        }
                                      }
                                    },
                                    audioPlayer: audioPlayer!,
                                    pinned: pinState is PinLoadedState &&
                                            pinState.pin != null &&
                                            selectedAyah != null
                                        ? (pinState.pin!.ayah ==
                                                selectedAyah!.numberInSurah &&
                                            pinState.pin!.surah ==
                                                widget.ref.number)
                                        : false),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
