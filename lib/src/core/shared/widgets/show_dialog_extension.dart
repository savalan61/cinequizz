// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

extension ShowDialogExtension on BuildContext {
  //* Info Dialog: A simple dialog that shows information with an "Ok" button.
  Future<bool?> showInfoDialog({
    required String title,
    String? content,
    String? actionText,
  }) =>
      showAdaptiveDialog(
        title: title,
        content: content,
        actions: [
          DialogButton(text: actionText ?? 'Ok', onPressed: pop),
        ],
      );

//* Adaptive Dialog: A customizable dialog that can be used in different situations.
  Future<T?> showAdaptiveDialog<T>({
    String? content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
    TextStyle? titleTextStyle,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: builder ??
            (context) {
              return AlertDialog.adaptive(
                actionsAlignment: MainAxisAlignment.end,
                title: Text(title!),
                titleTextStyle: titleTextStyle,
                content: content == null ? null : Text(content),
                actions: actions,
              );
            },
      );
//*Confirmation Dialog: A dialog that asks the user to confirm an action.
  Future<void> confirmAction({
    required void Function() fn,
    required String title,
    required String noText,
    required String yesText,
    String? content,
    TextStyle? yesTextStyle,
    TextStyle? noTextStyle,
    void Function(BuildContext context)? noAction,
  }) async {
    final isConfirmed = await showConfirmationDialog(
      title: title,
      content: content,
      noText: noText,
      yesText: yesText,
      yesTextStyle: yesTextStyle,
      noTextStyle: noTextStyle,
      noAction: noAction,
    );
    if (isConfirmed == null || !isConfirmed) return;
    fn.call();
  }

//*Bottom Modal: A modal that appears from the bottom of the screen.
  Future<bool?> showConfirmationDialog({
    required String title,
    required String noText,
    required String yesText,
    String? content,
    void Function(BuildContext context)? noAction,
    void Function(BuildContext context)? yesAction,
    TextStyle? noTextStyle,
    TextStyle? yesTextStyle,
    bool distractiveAction = true,
    bool barrierDismissible = true,
  }) =>
      showAdaptiveDialog<bool?>(
        title: title,
        content: content,
        barrierDismissible: barrierDismissible,
        titleTextStyle: headlineSmall,
        actions: [
          DialogButton(
            isDefaultAction: true,
            onPressed: () => noAction == null
                ? (canPop() ? pop(false) : null)
                : noAction.call(this),
            text: noText,
            textStyle: noTextStyle ?? labelLarge?.apply(color: adaptiveColor),
          ),
          DialogButton(
            isDestructiveAction: true,
            onPressed: () => yesAction == null
                ? (canPop() ? pop(true) : null)
                : yesAction.call(this),
            text: yesText,
            textStyle: yesTextStyle ?? labelLarge?.apply(color: AppColors.red),
          ),
        ],
      );

  Future<T?> showBottomModal<T>({
    Widget Function(BuildContext context)? builder,
    String? title,
    Color? titleColor,
    Widget? content,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? border,
    bool rounded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool useSafeArea = false,
    bool showDragHandle = false,
  }) =>
      showModalBottomSheet(
        context: this,
        shape: border ??
            (!rounded
                ? null
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  )),
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: useSafeArea,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        builder: builder ??
            (context) {
              return Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title,
                        style: context.titleLarge?.copyWith(color: titleColor),
                      ),
                      const Divider(),
                    ],
                    content!,
                  ],
                ),
              );
            },
      );
//* Scrollable Modal: A modal that can be scrolled, useful for large content.
  Future<void> showScrollableModal({
    required Widget Function(
      ScrollController scrollController,
      DraggableScrollableController draggableScrollController,
    ) pageBuilder,
    bool isDismissible = true,
    double initialChildSize = .7,
    bool showFullSized = false,
    bool showDragHandle = false,
    double minChildSize = .4,
    double maxChildSize = 1.0,
    bool withSnapSizes = true,
    bool snap = true,
    List<double>? snapSizes,
  }) =>
      showBottomModal<void>(
        isScrollControlled: true,
        showDragHandle: showDragHandle,
        isDismissible: isDismissible,
        builder: (context) {
          final controller = DraggableScrollableController();
          return DraggableScrollableSheet(
            controller: controller,
            expand: false,
            snap: snap,
            snapSizes: withSnapSizes ? snapSizes ?? const [.6, 1] : null,
            initialChildSize: showFullSized ? 1.0 : initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) =>
                pageBuilder.call(scrollController, controller),
          );
        },
      );
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    this.text,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    super.key,
    this.onPressed,
    this.style,
    this.textStyle,
  });

  final void Function()? onPressed;

  final String? text;

  final ButtonStyle? style;

  final TextStyle? textStyle;

  final bool isDefaultAction;

  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final text = _Text(
      text: this.text!,
      style: textStyle,
    );
    final effectiveChild = text;

    final platform = context.theme.platform;
    final isIOS = platform == TargetPlatform.iOS;

    return Builder(
      builder: (_) {
        if (isIOS) {
          return CupertinoDialogAction(
            onPressed: onPressed,
            isDefaultAction: isDefaultAction,
            isDestructiveAction: isDestructiveAction,
            child: effectiveChild,
          );
        } else {
          return TextButton(
            onPressed: onPressed,
            child: effectiveChild,
          );
        }
      },
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      overflow: TextOverflow.ellipsis,
      child: Text(text),
    );
  }
}
