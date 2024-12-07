// ignore_for_file: one_member_abstracts, avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum TappableVariant {
  normal,

  faded,

  scaled
}

abstract class _ParentTappableState {
  void markChildTappablePressed(
    _ParentTappableState childState,
    bool value,
  );
}

class _ParentTappableProvider extends InheritedWidget {
  const _ParentTappableProvider({
    required this.state,
    required super.child,
  });

  final _ParentTappableState state;

  @override
  bool updateShouldNotify(_ParentTappableProvider oldWidget) =>
      state != oldWidget.state;

  static _ParentTappableState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ParentTappableProvider>()
        ?.state;
  }
}

class Tappable extends StatelessWidget {
  const Tappable({
    required this.child,
    super.key,
    this.onTap,
    this.borderRadius = 0,
    this.backgroundColor,
    this.throttle = false,
    this.throttleDuration,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.scaleStrength,
    this.fadeStrength,
    this.scaleAlignment,
    this.boxShadow,
    this.enableFeedback = true,
  }) : _variant = TappableVariant.normal;

  const Tappable.raw({
    required this.child,
    required TappableVariant variant,
    super.key,
    this.onTap,
    this.borderRadius = 0,
    this.backgroundColor,
    this.throttle = false,
    this.throttleDuration,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.scaleStrength = ScaleStrength.sm,
    this.fadeStrength = FadeStrength.md,
    this.scaleAlignment = Alignment.center,
    this.boxShadow,
    this.enableFeedback = true,
  }) : _variant = variant;

  const Tappable.faded({
    required this.child,
    super.key,
    this.onTap,
    this.borderRadius = 0,
    this.backgroundColor,
    this.fadeStrength = FadeStrength.md,
    this.throttle = false,
    this.throttleDuration,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.boxShadow,
    this.enableFeedback = true,
  })  : _variant = TappableVariant.faded,
        scaleAlignment = null,
        scaleStrength = null;

  const Tappable.scaled({
    required this.child,
    super.key,
    this.onTap,
    this.borderRadius = 0,
    this.backgroundColor,
    this.throttle = false,
    this.throttleDuration,
    this.scaleStrength = ScaleStrength.sm,
    this.scaleAlignment = Alignment.center,
    this.onTapUp,
    this.onTapDown,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.boxShadow,
    this.enableFeedback = true,
  })  : _variant = TappableVariant.scaled,
        fadeStrength = null;

  final TappableVariant _variant;

  final double borderRadius;

  final bool enableFeedback;

  final GestureTapCallback? onTap;

  final GestureTapDownCallback? onTapDown;

  final GestureTapUpCallback? onTapUp;

  final Color? backgroundColor;

  final Widget child;

  final bool throttle;

  final Duration? throttleDuration;

  final GestureLongPressCallback? onLongPress;

  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  final GestureLongPressEndCallback? onLongPressEnd;

  final List<BoxShadow>? boxShadow;

  final ScaleStrength? scaleStrength;

  final FadeStrength? fadeStrength;

  final Alignment? scaleAlignment;

  @override
  Widget build(BuildContext context) {
    final parentState = _ParentTappableProvider.maybeOf(context);
    return _TappableStateWidget(
      onTap: onTap,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      enableFeedback: enableFeedback,
      variant: _variant,
      fadeStrength: fadeStrength,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      boxShadow: boxShadow,
      scaleAlignment: scaleAlignment,
      scaleStrength: scaleStrength,
      throttle: throttle,
      throttleDuration: throttleDuration,
      parentState: parentState,
      child: child,
    );
  }
}

class _TappableStateWidget extends StatefulWidget {
  const _TappableStateWidget({
    required this.child,
    required this.variant,
    this.onTap,
    this.borderRadius = 0,
    this.enableFeedback = true,
    this.backgroundColor,
    this.throttle = false,
    this.throttleDuration,
    this.onTapUp,
    this.onTapDown,
    this.parentState,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.boxShadow,
    this.scaleStrength,
    this.fadeStrength,
    this.scaleAlignment,
  });

  final TappableVariant variant;
  final double borderRadius;
  final bool enableFeedback;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final Color? backgroundColor;
  final Widget child;
  final bool throttle;
  final Duration? throttleDuration;
  final _ParentTappableState? parentState;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressEndCallback? onLongPressEnd;
  final List<BoxShadow>? boxShadow;
  final ScaleStrength? scaleStrength;
  final FadeStrength? fadeStrength;
  final Alignment? scaleAlignment;

  @override
  State<_TappableStateWidget> createState() => _TappableStateWidgetState();
}

class _TappableStateWidgetState extends State<_TappableStateWidget>
    with SingleTickerProviderStateMixin
    implements _ParentTappableState {
  final ObserverList<_ParentTappableState> _activeChildren =
      ObserverList<_ParentTappableState>();

  @override
  void markChildTappablePressed(
    _ParentTappableState childState,
    bool value,
  ) {
    final lastAnyPressed = _anyChildTappablePressed;
    if (value) {
      _activeChildren.add(childState);
    } else {
      _activeChildren.remove(childState);
    }
    final nowAnyPressed = _anyChildTappablePressed;
    if (nowAnyPressed != lastAnyPressed) {
      widget.parentState?.markChildTappablePressed(this, nowAnyPressed);
    }
  }

  bool get _anyChildTappablePressed => _activeChildren.isNotEmpty;

  void updateHighlight({required bool value}) {
    widget.parentState?.markChildTappablePressed(this, value);
  }

  static const animationOutDuration = Duration(milliseconds: 150);
  static const animationInDuration = Duration(milliseconds: 230);
  final Tween<double> _animationTween = Tween<double>(begin: 1);
  late double _animationValue = switch (widget.variant) {
    TappableVariant.faded => widget.fadeStrength!.strength,
    TappableVariant.scaled => widget.scaleStrength!.strength,
    _ => 0.0,
  };

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0,
      vsync: this,
    );
    _animation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_animationTween);
    _setTween();
  }

  @override
  void didUpdateWidget(covariant _TappableStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scaleStrength != widget.scaleStrength) {
      _animationValue = widget.scaleStrength?.strength ?? 0;
    } else if (oldWidget.fadeStrength != widget.fadeStrength) {
      _animationValue = widget.fadeStrength?.strength ?? 0;
    }
  }

  void _setTween() {
    _animationTween.end = 0.5;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void Function()? _handleTap() {
    if (widget.onTap == null) return null;
    return () {
      updateHighlight(value: false);
      if (widget.onTap != null) {
        if (widget.enableFeedback) {
          Feedback.forTap(context);
        }
        widget.onTap!.call();
      }
    };
  }

  void _handleTapDown(TapDownDetails event) {
    if (_anyChildTappablePressed) return;
    updateHighlight(value: true);
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
      widget.onTapDown?.call(event);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
    }
    if (_animationController.value < _animationValue) {
      _animationController
          .animateTo(
            _animationValue,
            duration: animationOutDuration,
            curve: Curves.easeInOutCubicEmphasized,
          )
          .then(
            (value) => _animationController.animateTo(
              0,
              duration: animationInDuration,
              curve: Curves.easeOutCubic,
            ),
          );
      widget.onTapUp?.call(event);
    }
    if (_animationController.value >= _animationValue) {
      _animationController.animateTo(
        0,
        duration: animationInDuration,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
    updateHighlight(value: false);
  }

  void _handleLongPress() {
    _animate();
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      widget.onLongPress!.call();
    }
  }

  void _animate() {
    final wasHeldDown = _buttonHeldDown;
    _buttonHeldDown
        ? _animationController.animateTo(
            _animationValue,
            duration: animationOutDuration,
            curve: Curves.easeInOutCubicEmphasized,
          )
        : _animationController
            .animateTo(
            0,
            duration: animationInDuration,
            curve: Curves.easeOutCubic,
          )
            .then(
            (_) {
              if (mounted && wasHeldDown != _buttonHeldDown) {
                _animate();
              }
            },
          );
  }

  Future<void> _onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      if (widget.onLongPress != null) widget.onLongPress!.call();
    }
  }

  @override
  void deactivate() {
    widget.parentState?.markChildTappablePressed(this, false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    Widget tappable({required VoidCallback? onTap}) => MouseRegion(
          cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
          child: IgnorePointer(
            ignoring: widget.onLongPress == null && onTap == null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: _handleTap(),
              onLongPressEnd: widget.onLongPressEnd,
              onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
              // Use null so other long press actions can be captured
              onLongPress: widget.onLongPress == null ? null : _handleLongPress,
              child: Semantics(
                button: true,
                child: _ButtonAnimationWrapper(
                  variant: widget.variant,
                  animation: _animation,
                  scaleAlignment: widget.scaleAlignment,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: widget.backgroundColor,
                      boxShadow: widget.boxShadow,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );

    if (widget.throttle) {
      button = ThrottledButton(
        onTap: _handleTap(),
        throttleDuration: widget.throttleDuration?.inMilliseconds,
        builder: (isThrottled, onTap) => tappable(onTap: onTap),
      );
    } else {
      button = tappable(onTap: _handleTap());
    }

    if (!kIsWeb && widget.onLongPress != null) {
      return _ParentTappableProvider(state: this, child: button);
    }

    return _ParentTappableProvider(
      state: this,
      child: Listener(
        onPointerDown: _onPointerDown,
        child: button,
      ),
    );
  }
}

class _ButtonAnimationWrapper extends StatelessWidget {
  const _ButtonAnimationWrapper({
    required this.variant,
    required this.child,
    required this.animation,
    this.scaleAlignment,
  });

  final TappableVariant variant;
  final Widget child;
  final Animation<double> animation;
  final Alignment? scaleAlignment;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      TappableVariant.faded => FadeTransition(opacity: animation, child: child),
      TappableVariant.scaled => ScaleTransition(
          scale: animation,
          alignment: scaleAlignment!,
          child: child,
        ),
      _ => child,
    };
  }
}

const kDefaultThrottlerDuration = 300;

class Throttler {
  Throttler({this.milliseconds = kDefaultThrottlerDuration});

  final int? milliseconds;

  Timer? timer;

  void run(VoidCallback action) {
    if (timer?.isActive ?? false) return;

    timer?.cancel();
    action();
    timer = Timer(
      Duration(milliseconds: milliseconds ?? kDefaultThrottlerDuration),
      () {},
    );
  }

  void dispose() {
    timer?.cancel();
  }
}

class ThrottledButton extends StatefulWidget {
  const ThrottledButton({
    required this.onTap,
    required this.builder,
    super.key,
    this.throttleDuration,
  });

  final VoidCallback? onTap;

  final int? throttleDuration;

  final Widget Function(bool isThrottled, VoidCallback? onTap) builder;

  @override
  State<ThrottledButton> createState() => _ThrottledButtonState();
}

class _ThrottledButtonState extends State<ThrottledButton> {
  late Throttler _throttler;

  late ValueNotifier<bool> _isThrottled;

  @override
  void initState() {
    super.initState();
    _throttler = Throttler(milliseconds: widget.throttleDuration);
    _isThrottled = ValueNotifier(false);
  }

  @override
  void dispose() {
    _throttler.dispose();
    _isThrottled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isThrottled,
      builder: (context, isThrottled, _) => widget.builder(
        isThrottled,
        isThrottled || widget.onTap == null
            ? null
            : () => _throttler.run(() {
                  _isThrottled.value = true;
                  widget.onTap?.call();
                  Future<void>.delayed(
                    Duration(
                      milliseconds: widget.throttleDuration ??
                          _throttler.milliseconds ??
                          350,
                    ),
                    () => _isThrottled.value = false,
                  );
                }),
      ),
    );
  }
}

enum FadeStrength {
  sm(.2),

  md(.4),

  lg(1);

  const FadeStrength(this.strength);

  final double strength;
}

enum ScaleStrength {
  xxxs(0.0325),

  xxs(0.0625),

  xs(0.125),

  sm(0.25),

  lg(0.5),

  xlg(0.75),

  xxlg(1);

  const ScaleStrength(this.strength);

  final double strength;
}
