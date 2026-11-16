import 'package:flutter/widgets.dart';

/// Form factor of the running layout (doc 15).
enum FormFactor { watch, phone, tablet }

/// Provides the form factor to every widget below it.
///
/// * The watch app wraps its tree with `DeviceProfile(formFactor: watch)`.
///   No runtime guessing on the watch.
/// * The mobile app uses [DeviceProfile.adaptive], which picks phone or
///   tablet by `shortestSide`, so rotation never changes the choice.
class DeviceProfile extends InheritedWidget {
  const DeviceProfile({
    required this.formFactor,
    required super.child,
    super.key,
  });

  final FormFactor formFactor;

  static const tabletBreakpoint = 600.0;

  static FormFactor of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DeviceProfile>()?.formFactor ??
      FormFactor.phone;

  static Widget adaptive({required Widget child}) => Builder(
    builder: (context) {
      final shortest = MediaQuery.sizeOf(context).shortestSide;
      return DeviceProfile(
        formFactor: shortest >= tabletBreakpoint
            ? FormFactor.tablet
            : FormFactor.phone,
        child: child,
      );
    },
  );

  @override
  bool updateShouldNotify(DeviceProfile oldWidget) =>
      oldWidget.formFactor != formFactor;
}

extension FormFactorX on BuildContext {
  FormFactor get formFactor => DeviceProfile.of(this);
  bool get isWatch => formFactor == FormFactor.watch;
  bool get isTablet => formFactor == FormFactor.tablet;
}

/// Picks a layout per form factor (doc 15). Falls back to [phone].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.phone,
    this.tablet,
    this.watch,
    super.key,
  });

  final Widget phone;
  final Widget? tablet;
  final Widget? watch;

  @override
  Widget build(BuildContext context) => switch (context.formFactor) {
    FormFactor.watch => watch ?? phone,
    FormFactor.tablet => tablet ?? phone,
    FormFactor.phone => phone,
  };
}

/// Centers [child] and limits its width on tablets (A.4 / A.6).
class MaxWidth extends StatelessWidget {
  const MaxWidth({required this.child, this.maxWidth = 480, super.key});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
