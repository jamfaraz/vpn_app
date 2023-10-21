import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_app/main.dart';

class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final Widget icon;
  const HomeCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .45,
      child: Column(
        children: [
          icon,
          const SizedBox(
            height: 6,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(subtitle,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).lightText))
        ],
      ),
    );
  }
}
