import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/app_card_tile.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({
    required this.imageUrl,
    required this.title,
    required this.trailing,
    required this.rating,
    required this.completedRatio,
    required this.correctNo,
    required this.wrongNo,
    required this.totalQuestionNo,
    required this.onTap,
    super.key,
  });
  final String imageUrl;
  final String title;
  final String trailing;
  final double rating;
  final double completedRatio;
  final int correctNo;
  final int wrongNo;
  final int totalQuestionNo;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCardTile(
                    icon: LucideIcons.tv,
                    title: title,
                    trailing: trailing,
                  ),
                  const Divider(),
                  AppCardTile(
                    icon: LucideIcons.squareCheck,
                    title: 'Correct : ',
                    trailing: correctNo.toString(),
                  ),
                  AppCardTile(
                    icon: LucideIcons.squareX,
                    title: 'Wrong : ',
                    trailing: wrongNo.toString(),
                  ),
                  AppCardTile(
                    icon: LucideIcons.rows2,
                    title: 'Answered : ',
                    trailing:
                        (completedRatio * totalQuestionNo).toStringAsFixed(0),
                  ),
                  AppCardTile(
                    icon: LucideIcons.rows4,
                    title: 'Questions :',
                    trailing: totalQuestionNo.toString(),
                  ),
                  const SizedBox(height: 10),
                  // SizedBox(
                  //   height: 15,
                  //   child: LiquidLinearProgressIndicator(
                  //     value: completedRatio,
                  //     valueColor: const AlwaysStoppedAnimation(
                  //       AppColors.primaryDar,
                  //     ),
                  //     backgroundColor: AppColors.darkGrey,
                  //     borderColor: AppColors.brightGrey,
                  //     borderWidth: 1,
                  //     borderRadius: 12,
                  //     center: Text(
                  //       '(${(100 * completedRatio).toStringAsFixed(0)}%) ${completedRatio == 1 ? 'Completed' : 'Completing...'} ',
                  //       style: context.bodySmall,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
