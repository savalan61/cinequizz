// ignore_for_file: public_member_api_docs

import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(
    String text, {
    bool dismissible = true,
    Color color = AppColors.white,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    SnackBarAction? snackBarAction,
    String? solution,
    DismissDirection dismissDirection = DismissDirection.down,
  }) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(text),
            action: snackBarAction,
            behavior: behavior,
            backgroundColor: color,
            dismissDirection: dismissDirection,
            duration: duration,
          ),
          // customSnackBar(
          //   text,
          //   behavior: behavior,
          //   color: color,
          //   dismissDirection: dismissDirection,
          //   dismissible: dismissible,
          //   duration: duration,
          //   snackBarAction: snackBarAction,
          //   solution: solution,
          // ),
        );

  void showUndismissableSnackBar(
    String text, {
    String? solution,
    Color color = AppColors.white,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        customSnackBar(
          text,
          behavior: SnackBarBehavior.floating,
          color: color,
          duration: const Duration(days: 1),
          snackBarAction: action,
          dismissible: false,
          solution: solution,
        ),
      );
  }

  void closeSnackBars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }
}

SnackBar customSnackBar(
  String text, {
  String? solution,
  bool dismissible = true,
  Color color = AppColors.white,
  Duration duration = const Duration(seconds: 4),
  SnackBarBehavior? behavior,
  SnackBarAction? snackBarAction,
  DismissDirection dismissDirection = DismissDirection.down,
}) {
  return SnackBar(
    dismissDirection: dismissible ? dismissDirection : DismissDirection.none,
    action: snackBarAction,
    duration: duration,
    behavior: behavior ?? SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.xs),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    content: solution == null
        ? Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: color),
          )
        : Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: color),
              ),
              Text(
                solution,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.brightGrey, fontSize: 14),
              ),
            ],
          ),
  );
}
