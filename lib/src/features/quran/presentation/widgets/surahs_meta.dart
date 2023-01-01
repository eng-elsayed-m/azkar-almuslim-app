import 'package:azkar/src/core/utils/configs/configs.dart';
import 'package:azkar/src/features/quran/domain/entities/surahs.dart';
import 'package:azkar/src/features/quran/presentation/pages/surah_screen.dart';
import 'package:flutter/material.dart';

class SurahsMeta extends StatelessWidget {
  final ReferencesEntity reference;
  const SurahsMeta({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SurahScreen(ref: reference),
      )),
      child: Card(
          elevation: 3,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  Image.asset(
                    'assets/images/ayah.png',
                    width: dSize.width * 0.2,
                  ),
                  Text(
                    reference.number.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ],
              ),
              Text(
                reference.name.toString(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontFamily: "AmiriQuran",
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
              ),
              Spacer(),
              Text(
                "عدد اللآيات ${reference.numberOfAyahs..toString()}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: "AmiriQuran", fontWeight: FontWeight.w900),
              ),
            ],
          )),
    );
  }
}
