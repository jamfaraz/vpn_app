import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/native_sd_controller.dart';
import '../../helpers/ad_helper.dart';
import '../../widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});
  final controller = LocationController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    if (controller.vpnList.isEmpty) controller.getVpnData();
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Text('VPN Locations (${controller.vpnList.length})'),
        ),
        bottomNavigationBar:
            // Config.hideAds ? null:
            _adController.ad != null && _adController.adLoaded.isTrue
                ? SafeArea(
                    child: SizedBox(
                        height: 85, child: AdWidget(ad: _adController.ad!)))
                : null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              onPressed: () => controller.getVpnData(),
              child: const Icon(CupertinoIcons.refresh)),
        ),
        body: controller.isLoading.value
            ? loadingWidget()
            : controller.vpnList.isEmpty
                ? noVpnFound()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: 11, right: 11, top: 16, bottom: 16),
                    itemCount: controller.vpnList.length,
                    itemBuilder: (context, index) {
                      return VpnCard(vpn: controller.vpnList[index]);
                    },
                  )));
  }

  loadingWidget() => SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/loading.json',
              height: Get.height * .36,
            ),
            const Text(
              'Loading VPNs... 😌',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  noVpnFound() => const Center(
        child: Text(
          'VPNs Not Found! 😔',
          style: TextStyle(
              color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
