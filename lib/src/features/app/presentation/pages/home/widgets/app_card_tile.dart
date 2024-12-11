import 'package:flutter/material.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

class AppCardTile extends StatelessWidget {
  const AppCardTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.color,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String trailing;
  final Color? color;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: context.bodyMedium,
              ),
            ],
          ),
          Text(
            trailing,
            style: context.bodyMedium!.copyWith(color: color ?? AppColors.grey),
          ),
        ],
      ),
    );
  }
}
