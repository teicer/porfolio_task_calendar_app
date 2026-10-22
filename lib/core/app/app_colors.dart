import 'package:flutter/material.dart';

final class AppColors {
  final Color transparent;
  final Color white;
  final Color error;
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
  // Selected Category
  final Color selected;

  // Card Shadow
  final List<BoxShadow> cardShadow;

  const AppColors._({
    required this.transparent,
    required this.white,
    required this.error,

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
    required this.selected,
    required this.cardShadow,
  });

  // Light Theme Constructor
  static AppColors get light => AppColors._(
    transparent: const Color.fromARGB(0, 0, 0, 0),
    white: const Color.fromARGB(255, 255, 255, 255),
    error: const Color.fromARGB(255, 255, 0, 0),

    // Base UI Colors
    bg: const Color.fromARGB(255, 255, 255, 255),
    overBg: const Color.fromARGB(255, 244, 247, 255),
    cardBorder: const Color.fromARGB(255, 230, 234, 242),
    primaryAccent: const Color.fromARGB(255, 40, 120, 245),

    // Typography
    primaryText: const Color.fromARGB(255, 30, 32, 34),
    secondaryText: const Color.fromARGB(255, 125, 133, 146),
    disabledText: const Color.fromARGB(255, 170, 176, 186),
    inverseText: const Color.fromARGB(255, 255, 255, 255),

    // Status Cards Backgrounds
    todayCardBg: const Color.fromARGB(255, 185, 199, 255),
    scheduledCardBg: const Color.fromARGB(255, 253, 229, 126),
    allCardBg: const Color.fromARGB(255, 188, 238, 226),
    overdueCardBg: const Color.fromARGB(255, 255, 181, 208),

    // Calendar Hints
    scheduledDot: const Color.fromARGB(255, 253, 205, 50),
    overdueDot: const Color.fromARGB(255, 255, 120, 160),

    // Category Cards
    grocery: const Color.fromARGB(255, 246, 219, 248),
    educational: const Color.fromARGB(255, 185, 201, 255),
    homeRelated: const Color.fromARGB(255, 254, 232, 126),
    workRelated: const Color.fromARGB(255, 50, 153, 105),
    mandatoryWork: const Color.fromARGB(255, 255, 186, 235),
    personalNotes: const Color.fromARGB(255, 196, 242, 226),
    hobbies: const Color.fromARGB(255, 255, 216, 176),
    fitnessHealth: const Color.fromARGB(255, 204, 242, 204),
    finance: const Color.fromARGB(255, 226, 222, 218),

    //Selected
    selected: const Color.fromARGB(255, 200, 200, 255),
    // Card Shadows
    cardShadow: const [BoxShadow(color: Color.fromARGB(15, 0, 0, 0), blurRadius: 4, offset: Offset(0, 2))],
  );

  // Dark Theme Constructor
  static AppColors get dark => AppColors._(
    transparent: const Color.fromARGB(0, 0, 0, 0),
    white: const Color.fromARGB(255, 255, 255, 255),
    error: const Color.fromARGB(255, 255, 0, 0),

    // Base UI Colors
    bg: const Color.fromARGB(255, 18, 20, 26),
    overBg: const Color.fromARGB(255, 28, 32, 43),
    cardBorder: const Color.fromARGB(255, 43, 49, 64),
    primaryAccent: const Color.fromARGB(255, 74, 137, 245),
    // Typography
    primaryText: const Color.fromARGB(255, 241, 243, 247),
    secondaryText: const Color.fromARGB(255, 155, 166, 184),
    disabledText: const Color.fromARGB(255, 92, 102, 117),
    inverseText: const Color.fromARGB(255, 255, 255, 255),

    // Status Cards Backgrounds
    todayCardBg: const Color.fromARGB(255, 32, 42, 78),
    scheduledCardBg: const Color.fromARGB(255, 72, 62, 24),
    allCardBg: const Color.fromARGB(255, 24, 60, 52),
    overdueCardBg: const Color.fromARGB(255, 74, 30, 46),

    // Calendar Hints
    scheduledDot: const Color.fromARGB(255, 247, 217, 91),
    overdueDot: const Color.fromARGB(255, 255, 77, 121),

    // Category Cards
    grocery: const Color.fromARGB(255, 246, 219, 248),
    educational: const Color.fromARGB(255, 185, 201, 255),
    homeRelated: const Color.fromARGB(255, 254, 232, 126),
    workRelated: const Color.fromARGB(255, 50, 153, 105),
    mandatoryWork: const Color.fromARGB(255, 255, 186, 235),
    personalNotes: const Color.fromARGB(255, 196, 242, 226),
    hobbies: const Color.fromARGB(255, 255, 216, 176),
    fitnessHealth: const Color.fromARGB(255, 204, 242, 204),
    finance: const Color.fromARGB(255, 226, 222, 218),
    //Selected
    selected: const Color.fromARGB(255, 200, 200, 255),

    // Card Shadows
    cardShadow: const [BoxShadow(color: Color.fromARGB(15, 0, 0, 0), blurRadius: 4, offset: Offset(0, 2))],
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
