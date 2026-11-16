/// Route paths shared by both apps.
abstract final class ShellPaths {
  static const splash = '/splash';
  static const update = '/update';
  static const home = '/home';
  static const history = '/history';

  /// `/history/:id`, one work order.
  static String workOrder(String id) => '$history/${Uri.encodeComponent(id)}';
  static const profile = '/profile';
  static const attendance = '/attendance';
}
