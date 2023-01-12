import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final void Function() play;
  final bool isPlaying;

  const QuoteCard(
      {Key? key,
      required this.quote,
      required this.play,
      required this.isPlaying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 5,
          title: EntranceFader(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 100),
            offset: const Offset(50.0, 0.0),
            child: Material(
              elevation: 0,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.normalize(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: isPlaying
                          ? const Icon(
                              Icons.pause,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.play_arrow_outlined,
                              color: Colors.green,
                              size: AppDimensions.normalize(30),
                            ),
                      onPressed: play,
                    ),
                    Text(
                      "#${quote.filename}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "التكرار : ${quote.count}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          subtitle: EntranceFader(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 100),
            offset: const Offset(50.0, 0.0),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: AppDimensions.normalize(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/top-deco.png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      quote.text!,
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          height: 2,
                          fontFamily: "AmiriQuran",
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottom-deco.png',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
