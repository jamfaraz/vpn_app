import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_app/main.dart';
import '../../controllers/home_controller.dart';
import '../../helpers/ad_helper.dart';
import '../../helpers/config.dart';
import '../../helpers/pref.dart';
import '../../services/vpn_engine.dart';
import '../../widgets/count_down_timer.dart';
import '../../widgets/home_card.dart';
import '../../widgets/watch_ad_dialog.dart';
import '../models/vpn_status.dart';
import 'location_screen.dart';
import 'network_screen.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeControlllers());

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen((event) {
      controller.vpnState.value = event;
    });

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(CupertinoIcons.home),
          actions: [
            IconButton(
                onPressed: () {
                  if (Config.hideAds) {
                    Get.changeThemeMode(
                        Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    Pref.isDarkMode = !Pref.isDarkMode;
                    return;
                  }

                  Get.dialog(WatchAdDialog(onComplete: () {
                    AdHelper.showRewardedAd(onComplete: () {
                      Get.changeThemeMode(
                          Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                      Pref.isDarkMode = !Pref.isDarkMode;
                    });
                  }));
                },
                icon: const Icon(Icons.brightness_medium_outlined)),
            IconButton(
                onPressed: () => Get.to(() => const NetworkTestScreen()),
                icon: const Icon(Icons.info_outline))
          ],
          title: const Text('JET VPN ')),
      bottomNavigationBar: _changeLocation(context),
      body: Column(children: [
        const SizedBox(
          height: 26,
          width: double.maxFinite,
        ),
        Obx(() => vpnButton()),
        const SizedBox(
          height: 35,
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                  title: controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : controller.vpn.value.countryLong,
                  subtitle: 'FREE',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    backgroundImage: controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${controller.vpn.value.countryShort.toLowerCase()}.png'),
                    child: controller.vpn.value.countryLong.isEmpty
                        ? const Icon(Icons.vpn_lock_rounded,
                            size: 30, color: Colors.white)
                        : null,
                  )),
              HomeCard(
                  title: controller.vpn.value.countryLong.isEmpty
                      ? '100 ms'
                      : '${controller.vpn.value.ping} ms',
                  subtitle: 'PING',
                  icon: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.equalizer_rounded,
                        size: 30, color: Colors.white),
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 19,
        ),
        StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeCard(
                        title: snapshot.data?.byteIn ?? '0 kbps',
                        subtitle: 'DOWNLOAD',
                        icon: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightGreen,
                          child: Icon(Icons.arrow_downward_rounded,
                              size: 30, color: Colors.white),
                        )),
                    HomeCard(
                        title: snapshot.data?.byteOut ?? '0 kbps',
                        subtitle: 'UPLOAD',
                        icon: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.arrow_upward_rounded,
                              size: 30, color: Colors.white),
                        )),
                  ],
                ))
      ]),
    );
  }

  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
                color: Theme.of(context).bottomNav,
                padding: EdgeInsets.symmetric(horizontal: Get.width * .04),
                height: 60,
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.globe, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'Change Location',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.keyboard_arrow_right_rounded,
                          color: Colors.blue, size: 26),
                    )
                  ],
                )),
          ),
        ),
      );

  Widget vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(111),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    height: Get.height * .15,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.power_settings_new_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          controller.getButtonText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 11),
            margin: const EdgeInsets.only(top: 14, bottom: 6),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 12.5, color: Colors.white),
            ),
          ),
          Obx(() => CountDownTimer(
              startTimer: controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );
}
