import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/auth_repository.dart';
import '../cubit/login_cubit.dart';

/// Sign-in for phone and tablet with KPK and the registered phone number as
/// the password (doc 3.1, A.4; backend `technician-auth/login`).
class LoginScreen extends StatelessWidget {
  const LoginScreen({
    required this.repository,
    required this.onSignedIn,
    required this.year,
    this.sessionEndMessage,
    this.onVendorLogin,
    super.key,
  });

  final AuthRepository repository;
  final ValueChanged<SessionInfo> onSignedIn;
  final int year;

  /// Shown once after an automatic sign-out (shift end, revoked).
  final String? sessionEndMessage;

  /// Route for Vendor Technician login. The button is shown only when the
  /// `vendor_technician_login` flag is on AND a route exists (doc 14).
  final VoidCallback? onVendorLogin;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoginCubit(repository),
    child: BlocListener<LoginCubit, LoginState>(
      listenWhen: (a, b) => a.signedIn == null && b.signedIn != null,
      listener: (context, state) => onSignedIn(state.signedIn!),
      child: _LoginView(
        year: year,
        sessionEndMessage: sessionEndMessage,
        onVendorLogin: onVendorLogin,
      ),
    ),
  );
}

class _LoginView extends StatefulWidget {
  const _LoginView({
    required this.year,
    this.sessionEndMessage,
    this.onVendorLogin,
  });

  final int year;
  final String? sessionEndMessage;
  final VoidCallback? onVendorLogin;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _kpk = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _kpk.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    final cubit = context.read<LoginCubit>();
    final showVendor =
        widget.onVendorLogin != null &&
        context.read<FeatureFlags>().isEnabled(
          FeatureFlag.vendorTechnicianLogin,
        );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: MaxWidth(
                maxWidth: AppShape.tabletContentMaxWidth,
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) => AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppLogoHeader(),
                        const SizedBox(height: 28),
                        Text(l10n.loginTitle, style: theme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(
                          l10n.loginSubtitle,
                          style: theme.bodyMedium?.copyWith(color: c.textMuted),
                        ),
                        const SizedBox(height: 24),
                        if (widget.sessionEndMessage != null) ...[
                          NoticeBanner(message: widget.sessionEndMessage!),
                          const SizedBox(height: 16),
                        ],
                        AppTextField(
                          label: l10n.kpkLabel,
                          hint: l10n.kpkHint,
                          icon: LucideIcons.idCard,
                          controller: _kpk,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          enabled: !state.submitting,
                          errorText:
                              state.kpkError == LoginFieldError.invalidKpk
                              ? l10n.kpkInvalid
                              : null,
                          onChanged: cubit.kpkChanged,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: l10n.passwordLabel,
                          hint: l10n.passwordHint,
                          icon: LucideIcons.lock,
                          controller: _password,
                          obscure: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          enabled: !state.submitting,
                          keyboardType: TextInputType.phone,
                          errorText: state.invalidCredentials
                              ? l10n.loginInvalid
                              : null,
                          onChanged: cubit.passwordChanged,
                          onSubmitted: (_) => cubit.submit(),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          value: state.remember,
                          onChanged: state.submitting
                              ? null
                              : (v) => cubit.rememberChanged(v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(l10n.rememberMe, style: theme.bodyMedium),
                        ),
                        if (state.failure != null) ...[
                          const SizedBox(height: 4),
                          NoticeBanner(
                            message: failureText(l10n, state.failure!),
                            tone: NoticeTone.blocking,
                          ),
                        ],
                        const SizedBox(height: 16),
                        AppButton(
                          label: l10n.loginButton,
                          variant: AppButtonVariant.brand,
                          loading: state.submitting,
                          onPressed: state.canSubmit ? cubit.submit : null,
                        ),
                        if (showVendor) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  l10n.loginDivider,
                                  style: theme.bodySmall,
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: l10n.loginAsVendorTechnician,
                            variant: AppButtonVariant.outlined,
                            onPressed: widget.onVendorLogin,
                          ),
                        ],
                        const SizedBox(height: 32),
                        CopyrightText(year: widget.year),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
