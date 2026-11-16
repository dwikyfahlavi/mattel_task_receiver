import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/generated/app_localizations.dart';
import 'app_button.dart';
import 'status_widgets.dart';

/// Blocking "Perbarui Aplikasi" (doc 13). The user cannot sign in or check
/// in. Full APKs normally arrive via MDM; the in-app download is offered
/// only with the `in_app_apk_update` flag and an APK in the config.
class UpdateRequiredScreen extends StatefulWidget {
  const UpdateRequiredScreen({
    required this.config,
    required this.inAppUpdateEnabled,
    required this.updater,
    required this.onRetry,
    this.dismissible = false,
    super.key,
  });

  final RemoteAppConfig? config;
  final bool inAppUpdateEnabled;
  final ApkUpdater updater;
  final VoidCallback onRetry;

  /// True for the soft update (opened from the prompt).
  final bool dismissible;

  @override
  State<UpdateRequiredScreen> createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  double? _progress;
  String? _error;

  Future<void> _download() async {
    final apk = widget.config?.apk;
    if (apk == null) return;
    final l10n = AppLocalizations.of(context);
    if (!await widget.updater.canInstall()) {
      setState(() => _error = l10n.updateInstallPermission);
      await widget.updater.openInstallPermissionSettings();
      return;
    }
    setState(() {
      _progress = 0;
      _error = null;
    });
    final r = await widget.updater.download(
      apk,
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );
    if (!mounted) return;
    await r.fold(
      (file) async {
        setState(() => _progress = null);
        await widget.updater.install(file);
      },
      (_) async => setState(() {
        _progress = null;
        _error = l10n.updateFailed;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final canDownload = widget.inAppUpdateEnabled && widget.config?.apk != null;
    final progress = _progress;
    return PopScope(
      canPop: widget.dismissible,
      child: Scaffold(
        appBar: widget.dismissible ? AppBar() : null,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.refreshCw, size: 48, color: c.primary),
                    const SizedBox(height: 16),
                    Text(
                      l10n.updateTitle,
                      style: theme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.dismissible
                          ? l10n.updateSoftBody
                          : l10n.updateForceBody,
                      textAlign: TextAlign.center,
                      style: theme.bodyMedium?.copyWith(color: c.textMuted),
                    ),
                    const SizedBox(height: 20),
                    if (progress != null) ...[
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 8),
                      Text(l10n.updateDownloading((progress * 100).round())),
                    ] else if (canDownload)
                      AppButton(label: l10n.updateNow, onPressed: _download)
                    else
                      NoticeBanner(message: l10n.updateManaged),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      NoticeBanner(message: _error!, tone: NoticeTone.blocking),
                    ],
                    const SizedBox(height: 12),
                    AppButton(
                      label: l10n.actionRetry,
                      variant: AppButtonVariant.secondary,
                      onPressed: progress == null ? widget.onRetry : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dismissible soft-update prompt (at most once per shift, doc 13.1).
/// Without [onUpdate] (no in-app path) it explains that MDM installs it.
Future<void> showSoftUpdateDialog(
  BuildContext context, {
  VoidCallback? onUpdate,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l10n.updateTitle),
      content: Text(
        onUpdate == null
            ? '${l10n.updateSoftBody}\n\n${l10n.updateManaged}'
            : l10n.updateSoftBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l10n.updateLater),
        ),
        if (onUpdate != null)
          FilledButton(
            onPressed: () {
              Navigator.pop(c);
              onUpdate();
            },
            child: Text(l10n.updateNow),
          ),
      ],
    ),
  );
}
