import 'package:flutter/material.dart';

class AppNumbers {
  static const double padding = 20;
  static const double paddingSmall = 10;
  static const double space = 8;
  static const double spaceSmall = 4;
  static const double radius = 32;
  static const double radiusSm = 16;
  static const int animDuration = 300;

  static double title(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.08;
  }

  static double getH1(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.065;
  }

  static double getH2(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.055;
  }

  static double getH3(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.045;
  }

  static double body(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.04;
  }

  static double caption(BuildContext context) {
    final mq = MediaQuery.of(context);
    return mq.size.width * 0.03;
  }

  static double iconXs(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.035;
  }

  static double iconSm(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.05;
  }

  static double iconMd(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.07;
  }

  static double iconLg(BuildContext context) {
    final mq = MediaQuery.of(context);

    return mq.size.width * 0.1;
  }
}
