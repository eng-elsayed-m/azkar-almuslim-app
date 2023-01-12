import 'package:adhan/adhan.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/home/widgets/title_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class PrayersTimesWidget extends StatefulWidget {
  const PrayersTimesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PrayersTimesWidget> createState() => _PrayersTimesWidgetState();
}

class _PrayersTimesWidgetState extends State<PrayersTimesWidget> {
  final location = Location();
  String? locationError;
  PrayerTimes? prayerTimes;
  SunnahTimes? sunnahTimes;
  Qibla? qibla;
  @override
  void initState() {
    super.initState();
    getLocationData().then((locationData) {
      print(locationData.toString());
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        setState(() {
          prayerTimes = PrayerTimes(
              Coordinates(locationData.latitude!, locationData.longitude!),
              DateComponents.from(DateTime.now()),
              CalculationMethod.egyptian.getParameters());
          if (prayerTimes != null) sunnahTimes = SunnahTimes(prayerTimes!);
          qibla = Qibla(
              Coordinates(locationData.latitude!, locationData.longitude!));
        });
      } else {
        setState(() {
          locationError = "Couldn't Get Your Location!";
        });
      }
    });
  }

  Future<LocationData?> getLocationData() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleCard(
            title: Text(
          'مواقيت الصلاة',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white60),
        )),
        Builder(
          builder: (BuildContext context) {
            if (prayerTimes != null) {
              return SizedBox(
                height: AppDimensions.normalize(40),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TimeCard(
                        text:
                            'الفجر : ${DateFormat.jm('ar').format(prayerTimes!.fajr)}'),
                    const SizedBox(width: 5),
                    TimeCard(
                        text:
                            'الشروق  - ${DateFormat.jm("ar").format(prayerTimes!.sunrise)}'),
                    TimeCard(
                        text:
                            'الضهر ${DateFormat.jm('ar').format(prayerTimes!.dhuhr)}'),
                    TimeCard(
                        text:
                            'العصر ${DateFormat.jm('ar').format(prayerTimes!.asr)}'),
                    TimeCard(
                        text:
                            'المغرب ${DateFormat.jm('ar').format(prayerTimes!.maghrib)}'),
                    TimeCard(
                        text:
                            'العشاء ${DateFormat.jm('ar').format(prayerTimes!.isha)}'),
                    TimeCard(
                        text:
                            'العشاء ${DateFormat.jm('ar').format(prayerTimes!.isha)}'),
                    TimeCard(
                        text:
                            'منتصف الليل ${sunnahTimes == null ? '-' : DateFormat.jm('ar').format(sunnahTimes!.middleOfTheNight)}'),
                    TimeCard(
                        text:
                            'الربع الاخير : ${sunnahTimes == null ? '-' : DateFormat.jm('ar').format(sunnahTimes!.lastThirdOfTheNight)}'),
                  ],
                ),
              );
            }
            if (locationError != null) {
              return Text(locationError!);
            }
            return SizedBox(
                height: AppDimensions.normalize(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'جارى تحديد موقعك',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    AppIndicator()
                  ],
                ));
          },
        ),
      ],
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
          label: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: ""),
      )),
    );
  }
}
