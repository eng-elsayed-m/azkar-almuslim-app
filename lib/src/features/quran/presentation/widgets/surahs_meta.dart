import 'package:azkar/src/features/quran/domain/entities/surahs.dart';
import 'package:azkar/src/features/quran/presentation/pages/surah_screen.dart';
import 'package:flutter/material.dart';

class SurahsMeta extends StatelessWidget {
  final ReferencesEntity reference;
  final bool pinned;
  const SurahsMeta({super.key, required this.reference, this.pinned = false});

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    String rType(String type) {
      return type == "Meccan" ? 'مكية' : "مدنية";
    }

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
                    width: dSize.width * 0.18,
                    color: pinned ? Colors.green.withOpacity(0.6) : null,
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
              Card(
                child: Text(
                  "${reference.numberOfAyahs..toString()} أية",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: "AmiriQuran", fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  rType(reference.revelationType!),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: "AmiriQuran", fontWeight: FontWeight.w900),
                ),
              ),
            ],
          )),
    );
  }
}
