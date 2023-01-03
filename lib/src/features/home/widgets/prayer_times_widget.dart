import 'package:adhan/adhan.dart';
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
          style: Theme.of(context).textTheme.titleLarge,
        )),
        Builder(
          builder: (BuildContext context) {
            if (prayerTimes != null) {
              return SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Chip(
                      label: Text(
                          'الفجر : ${DateFormat.jm().format(prayerTimes!.fajr)}'),
                    ),
                    const SizedBox(width: 5),
                    Chip(
                        label: Text(
                            'الشروق : ${DateFormat.jm().format(prayerTimes!.sunrise)}')),
                    const SizedBox(width: 5),
                    Chip(
                      label: Text(
                          'الضهر: ${DateFormat.jm().format(prayerTimes!.dhuhr)}'),
                    ),
                    const SizedBox(width: 5),
                    Chip(
                      label: Text(
                          'العصر: ${DateFormat.jm().format(prayerTimes!.asr)}'),
                    ),
                    const SizedBox(width: 5),
                    Chip(
                      label: Text(
                          'المغرب: ${DateFormat.jm().format(prayerTimes!.maghrib)}'),
                    ),
                    const SizedBox(width: 5),
                    Chip(
                      label: Text(
                          'العشاء: ${DateFormat.jm().format(prayerTimes!.isha)}'),
                    ),
                    const SizedBox(width: 5),
                    Chip(
                      label: Text(
                          'العشاء: ${DateFormat.jm().format(prayerTimes!.isha)}'),
                    ),
                  ],
                ),
              );
            }
            if (locationError != null) {
              return Text(locationError!);
            }
            return SizedBox(
                height: 50,
                child:
                    Center(child: const Text('Waiting for Your Location...')));
          },
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text(
                    'سنة منتصف الليل: ${sunnahTimes == null ? '-' : DateFormat.jm().format(sunnahTimes!.middleOfTheNight)}'),
              ),
            ),
            Chip(
              label: Text(
                  'سنة الربع الاخير : ${sunnahTimes == null ? '-' : DateFormat.jm().format(sunnahTimes!.lastThirdOfTheNight)}'),
            ),
          ],
        ),
      ],
    );
  }
}
