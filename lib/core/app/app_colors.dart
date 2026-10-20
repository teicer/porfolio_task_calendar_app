import 'package:flutter/material.dart';

final class AppColors {
  final Color transparent;
  final Color white;

  // Base UI Colors
  final Color bg;
  final Color overBg;
  final Color cardBorder;
  final Color primaryAccent;

  // Typography
  final Color primaryText;
  final Color secondaryText;
  final Color disabledText;
  final Color inverseText;

  // Status Cards Backgrounds
  final Color todayCardBg;
  final Color scheduledCardBg;
  final Color allCardBg;
  final Color overdueCardBg;

  // Calendar Hints
  final Color scheduledDot;
  final Color overdueDot;

  // Categories Colors
  final Color grocery;
  final Color educational;
  final Color homeRelated;
  final Color workRelated;
  final Color mandatoryWork;
  final Color personalNotes;
  final Color hobbies;
  final Color fitnessHealth;
  final Color finance;

  // Card Shadow
  final List<BoxShadow> cardShadow;

  const AppColors._({
    required this.transparent,
    required this.white,
    required this.bg,
    required this.overBg,
    required this.cardBorder,
    required this.primaryAccent,
    required this.primaryText,
    required this.secondaryText,
    required this.disabledText,
    required this.inverseText,
    required this.todayCardBg,
    required this.scheduledCardBg,
    required this.allCardBg,
    required this.overdueCardBg,
    required this.scheduledDot,
    required this.overdueDot,
    required this.grocery,
    required this.educational,
    required this.homeRelated,
    required this.workRelated,
    required this.mandatoryWork,
    required this.personalNotes,
    required this.hobbies,
    required this.fitnessHealth,
    required this.finance,
    required this.cardShadow,
  });

  // Light Theme Constructor
  static AppColors get light => const AppColors._(
    transparent: Color.fromARGB(0, 0, 0, 0),
    white: Color.fromARGB(255, 255, 255, 255),

    // Base UI Colors
    bg: Color.fromARGB(255, 255, 255, 255),
    overBg: Color.fromARGB(255, 244, 247, 255),
    cardBorder: Color.fromARGB(255, 230, 234, 242),
    primaryAccent: Color.fromARGB(255, 40, 120, 245),

    // Typography
    primaryText: Color.fromARGB(255, 30, 32, 34),
    secondaryText: Color.fromARGB(255, 125, 133, 146),
    disabledText: Color.fromARGB(255, 170, 176, 186),
    inverseText: Color.fromARGB(255, 255, 255, 255),

    // Status Cards Backgrounds
    todayCardBg: Color.fromARGB(255, 185, 199, 255),
    scheduledCardBg: Color.fromARGB(255, 253, 229, 126),
    allCardBg: Color.fromARGB(255, 188, 238, 226),
    overdueCardBg: Color.fromARGB(255, 255, 181, 208),

    // Calendar Hints
    scheduledDot: Color.fromARGB(255, 253, 205, 50),
    overdueDot: Color.fromARGB(255, 255, 120, 160),

    // Category Cards
    grocery: Color.fromARGB(255, 246, 219, 248),
    educational: Color.fromARGB(255, 185, 201, 255),
    homeRelated: Color.fromARGB(255, 254, 232, 126),
    workRelated: Color.fromARGB(255, 50, 153, 105),
    mandatoryWork: Color.fromARGB(255, 255, 186, 235),
    personalNotes: Color.fromARGB(255, 196, 242, 226),
    hobbies: Color.fromARGB(255, 255, 216, 176),
    fitnessHealth: Color.fromARGB(255, 204, 242, 204),
    finance: Color.fromARGB(255, 226, 222, 218),

    // Card Shadows
    cardShadow: [BoxShadow(color: Color.fromARGB(15, 0, 0, 0), blurRadius: 4, offset: Offset(0, 2))],
  );

  // Dark Theme Constructor
  static AppColors get dark => const AppColors._(
    transparent: Color.fromARGB(0, 0, 0, 0),

    white: Color.fromARGB(255, 255, 255, 255),

    // Base UI Colors
    bg: Color.fromARGB(255, 18, 20, 26),
    overBg: Color.fromARGB(255, 28, 32, 43),
    cardBorder: Color.fromARGB(255, 43, 49, 64),
    primaryAccent: Color.fromARGB(255, 74, 137, 245),

    // Typography
    primaryText: Color.fromARGB(255, 241, 243, 247),
    secondaryText: Color.fromARGB(255, 155, 166, 184),
    disabledText: Color.fromARGB(255, 92, 102, 117),
    inverseText: Color.fromARGB(255, 255, 255, 255),

    // Status Cards Backgrounds
    todayCardBg: Color.fromARGB(255, 32, 42, 78),
    scheduledCardBg: Color.fromARGB(255, 72, 62, 24),
    allCardBg: Color.fromARGB(255, 24, 60, 52),
    overdueCardBg: Color.fromARGB(255, 74, 30, 46),

    // Calendar Hints
    scheduledDot: Color.fromARGB(255, 247, 217, 91),
    overdueDot: Color.fromARGB(255, 255, 77, 121),

    // Category Cards
    grocery: Color.fromARGB(255, 246, 219, 248),
    educational: Color.fromARGB(255, 185, 201, 255),
    homeRelated: Color.fromARGB(255, 254, 232, 126),
    workRelated: Color.fromARGB(255, 50, 153, 105),
    mandatoryWork: Color.fromARGB(255, 255, 186, 235),
    personalNotes: Color.fromARGB(255, 196, 242, 226),
    hobbies: Color.fromARGB(255, 255, 216, 176),
    fitnessHealth: Color.fromARGB(255, 204, 242, 204),
    finance: Color.fromARGB(255, 226, 222, 218),

    // Card Shadows
    cardShadow: [BoxShadow(color: Color.fromARGB(15, 0, 0, 0), blurRadius: 4, offset: Offset(0, 2))],
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
