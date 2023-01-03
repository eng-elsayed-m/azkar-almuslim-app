import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/utils/nav.dart';
import 'package:azkar/src/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = '/intro';

  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 350),
                offset: const Offset(0.0, -30.0),
                child: Image.asset(
                  'assets/images/frame-t.png',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: EntranceFader(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 350),
              offset: const Offset(32.0, 0.0),
              child: Image.asset(
                'assets/images/frame-b.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimensions.normalize(50)),
                  child: EntranceFader(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 350),
                    offset: const Offset(0.0, 32.0),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EntranceFader(
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 350),
                          offset: const Offset(0.0, 32.0),
                          child: Image.asset(
                            'assets/images/logo-t.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    NV.nextScreenReplaceNamed(context, HomeScreen.routeName);
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EntranceFader(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 350),
                            offset: const Offset(32.0, 0.0),
                            child: Text(
                              'متابعة',
                              style: TextStyle(
                                  fontFamily: "A-Hemmat",
                                  fontSize: AppDimensions.font(18),
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            width: AppDimensions.normalize(10),
                          ),
                          EntranceFader(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 350),
                            offset: const Offset(32.0, 0.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: AppDimensions.normalize(30),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
