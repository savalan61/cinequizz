import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/routes/_routes.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RulesModal extends StatelessWidget {
  const RulesModal({
    super.key,
    required this.series,
  });
  final SeriesEntity series;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Basic Rules',
            style: context.bodyLarge!,
          ),
          ListTile(
            leading: const Icon(LucideIcons.circleAlert),
            title: Text(
              'Only one of the four answers is correct',
              style: context.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(LucideIcons.circleAlert),
            title: RichText(
              text: TextSpan(
                style: context.bodyMedium,
                children: [
                  const TextSpan(text: 'Each question has a time limit of '),
                  TextSpan(
                    text: '${AppConstants.questionTimeLimit}',
                    style: context.bodyMedium!.copyWith(color: AppColors.red),
                  ),
                  const TextSpan(text: ' seconds.'),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(LucideIcons.circleAlert),
            title: RichText(
              text: TextSpan(
                style: context.bodyMedium,
                children: const [
                  TextSpan(text: 'Correct answers earn '),
                  TextSpan(
                    text: '${AppConstants.correctAnsScore}',
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(text: ' points, incorrect answers deduct '),
                  TextSpan(
                    text: '${AppConstants.wrongAnsScore}',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                      text:
                          ' points, and unanswered questions score 0 points.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShadButton.outline(
                backgroundColor: Colors.transparent,
                pressedBackgroundColor: Colors.transparent,
                onPressed: () => context.pop(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.white)),
              ),
              ShadButton(
                pressedBackgroundColor: Colors.transparent,
                onPressed: () {
                  context
                    ..pushNamed(
                      AppRoutes.question.name,
                      pathParameters: {'series_id': series.seriesId},
                    )
                    ..pop();
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
