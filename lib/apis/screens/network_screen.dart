import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/network_widget.dart';
import '../apis.dart';
import '../models/ip_detail.dart';
import '../models/network_model.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(title: const Text('Network Test Screen')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
            onPressed: () {
              ipData.value = IPDetails.fromJson({});
              APIs.getIPDetails(ipData: ipData);
            },
            child: const Icon(CupertinoIcons.refresh)),
      ),
      body: Obx(
        () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                left: Get.width * .04,
                right: Get.width * .04,
                top: Get.height * .01,
                bottom: Get.height * .1),
            children: [
              NetworkCard(
                  data: NetworkData(
                      title: 'IP Address',
                      subtitle: ipData.value.query,
                      icon: const Icon(CupertinoIcons.location_solid,
                          color: Colors.blue))),
              NetworkCard(
                  data: NetworkData(
                      title: 'Internet Provider',
                      subtitle: ipData.value.isp,
                      icon: const Icon(Icons.business, color: Colors.orange))),
              NetworkCard(
                  data: NetworkData(
                      title: 'Location',
                      subtitle: ipData.value.country.isEmpty
                          ? 'Fetching ...'
                          : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                      icon: const Icon(CupertinoIcons.location,
                          color: Colors.pink))),
              NetworkCard(
                  data: NetworkData(
                      title: 'Pin-code',
                      subtitle: ipData.value.zip,
                      icon: const Icon(CupertinoIcons.location_solid,
                          color: Colors.cyan))),
              NetworkCard(
                  data: NetworkData(
                      title: 'Timezone',
                      subtitle: ipData.value.timezone,
                      icon: const Icon(CupertinoIcons.time,
                          color: Colors.green))),
            ]),
      ),
    );
  }
}
