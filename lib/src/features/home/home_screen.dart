import 'package:adhan/adhan.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/utils/nav.dart';
import 'package:azkar/src/features/home/widgets/qiblaa.dart';
import 'package:azkar/src/features/home/widgets/names_section.dart';
import 'package:azkar/src/features/home/widgets/prayer_times_widget.dart';
import 'package:azkar/src/features/home/widgets/quotes_section.dart';
import 'package:azkar/src/features/quran/presentation/pages/surahs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 25),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: TabBar(
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey.shade400,
                overlayColor: MaterialStateProperty.all(Colors.white),
                tabs: const [
                  Icon(Icons.home_filled),
                  Icon(Icons.event_note_outlined),
                  Icon(Icons.book)
                ]),
          ),
          appBar: AppBar(
              // backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(AppDimensions.normalize(150)),
                  child: Expanded(
                    child: Image.asset(
                      'assets/images/header-bg (1).png',
                      fit: BoxFit.fitWidth,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  )),
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child: EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 350),
                  offset: const Offset(0.0, -50.0),
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: EntranceFader(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 350),
                    offset: const Offset(0.0, -50.0),
                    child: IconButton(
                        onPressed: () =>
                            NV.nextScreenNamed(context, '/settings'),
                        icon: Icon(
                          Icons.settings,
                          color: theme.scaffoldBackgroundColor,
                          size: 30,
                        )),
                  ),
                )
              ]),
          body: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PrayersTimesWidget(),
                  const NamesSection(),
                  Expanded(
                      child: Qiblaa(
                    qibla: qibla,
                  )),
                ],
              ),
              const QuotesSection(),
              const SurahsPage(),
            ],
          )),
    );
  }
}
