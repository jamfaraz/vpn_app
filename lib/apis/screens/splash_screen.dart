import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vpn_app/main.dart';
import '../../helpers/ad_helper.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      AdHelper.precacheInterstitialAd();
      AdHelper.precacheNativeAd();
      Get.to(() => HomeScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 77,
          ),
          Image.asset(
            'assets/images/logo.png',
            height: 188,
          ),
          const SizedBox(
            height: 344,
          ),
          Center(
              child: Text(
            'MADE IN PAKISTAN WITH ❤️',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).lightText),
          ))
        ],
      ),
    );
  }
}
