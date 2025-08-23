import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest/src/config/router/app_router.dart' show router;
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/core/constants/router_paths.dart';
import 'package:zest/main.dart' show loggedIn;

import 'auth_constants.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('loggedIn', true);
    loggedIn = true;
    router.replace(RouterPaths.home);
  }

  @override
  Widget build(BuildContext context) {
    // Changed to LTR
    return Scaffold(
      backgroundColor: AuthConstants.backgroundColor,
      body: Stack(
        children: [
          const _BackgroundBlobs(),
          SafeArea(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const mobileBreakpoint = 700;
                  final isMobileLayout = constraints.maxWidth < mobileBreakpoint;
    
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AuthConstants.primaryPadding),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AuthConstants.maxWidth,
                      ),
                      child: isMobileLayout
                          ? _MobileLayout(
                              form: _buildAuthCard(),
                            )
                          : _WideLayout(
                              hero: const _HeroPanel(),
                              form: _buildAuthCard(),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return _AuthCard(
      isLogin: _isLogin,
      onToggle: (v) => setState(() => _isLogin = v),
      formKey: _formKey,
      nameCtrl: _nameCtrl,
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      confirmCtrl: _confirmCtrl,
      obscure: _obscure,
      onToggleObscure: () => setState(() => _obscure = !_obscure),
      onSubmit: _submit,
    );
  }
}

/// Brand Header
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (r) => const LinearGradient(
              colors: AuthConstants.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(r),
            child: const Text(
              AuthConstants.brandTitle,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: AuthConstants.titleFontSize,
                fontWeight: AuthConstants.titleFontWeight,
                color: AuthConstants.primaryTextColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: AuthConstants.spaceSmall),
          const Text(
            AuthConstants.brandSubtitle,
            style: TextStyle(
              color: AuthConstants.secondaryTextColor,
              fontSize: AuthConstants.subtitleFontSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile Layout
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.form});
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _BrandHeader(),
        const SizedBox(height: AuthConstants.spaceExtraLarge),
        form,
      ],
    );
  }
}

/// Wide Layout (Desktop/Tablet)
class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.hero, required this.form});
  final Widget hero;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: hero),
        const SizedBox(width: AuthConstants.spaceWideLayout),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AuthConstants.cardMaxWidth),
          child: form,
        ),
      ],
    );
  }
}

/// Hero Panel (for wide layouts)
class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _BrandHeader(),
        SizedBox(height: AuthConstants.spaceExtraLarge),
        Text(
          AuthConstants.heroPanelText,
          style: TextStyle(
            color: AuthConstants.secondaryTextColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

/// Auth Form Card
class _AuthCard extends StatelessWidget {
  // ... (Constructor remains the same)
  const _AuthCard({
    required this.isLogin,
    required this.onToggle,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.confirmCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  final bool isLogin;
  final ValueChanged<bool> onToggle;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController confirmCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;


  InputDecoration _dec(String hint, {IconData? icon, Widget? tail}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AuthConstants.secondaryTextColor),
      prefixIcon:
          icon != null ? Icon(icon, color: AuthConstants.iconColor) : null,
      suffixIcon: tail,
      filled: true,
      fillColor: AuthConstants.inputFillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthConstants.inputBorderRadius),
        borderSide: const BorderSide(color: AuthConstants.inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthConstants.inputBorderRadius),
        borderSide: const BorderSide(color: AuthConstants.focusedInputBorderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AuthConstants.cardBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: AuthConstants.glassBlur, sigmaY: AuthConstants.glassBlur),
        child: Container(
          decoration: BoxDecoration(
            color: AuthConstants.glassCardColor,
            borderRadius:
                BorderRadius.circular(AuthConstants.cardBorderRadius),
            border: Border.all(color: AuthConstants.inputBorderColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: AuthConstants.cardBoxShadowBlur,
                spreadRadius: AuthConstants.cardBoxShadowSpread,
                offset: Offset(0, 16),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            AuthConstants.primaryPadding,
            AuthConstants.primaryPadding,
            AuthConstants.primaryPadding,
            16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Segmented(
                  left: AuthConstants.loginTab,
                  right: AuthConstants.signupTab,
                  value: isLogin,
                  onChanged: onToggle,
                ),
                const SizedBox(height: AuthConstants.spaceLarge),
                AnimatedSwitcher(
                  duration: AuthConstants.formSwitchDuration,
                  child: isLogin
                      ? Column(
                          key: const ValueKey('login'),
                          children: [
                            TextFormField(
                              controller: emailCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              validator: (v) => (v == null || v.isEmpty) ? AuthConstants.emailValidation : null,
                              decoration: _dec(AuthConstants.emailHint, icon: Icons.alternate_email),
                            ),
                            const SizedBox(height: AuthConstants.spaceMedium),
                            TextFormField(
                              controller: passCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              obscureText: obscure,
                              validator: (v) => (v == null || v.length < 6) ? AuthConstants.passwordValidation : null,
                              decoration: _dec(
                                AuthConstants.passwordHint,
                                icon: Icons.lock_outline,
                                tail: IconButton(
                                  onPressed: onToggleObscure,
                                  icon: Icon(
                                    obscure ? Icons.visibility : Icons.visibility_off,
                                    color: AuthConstants.iconColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AuthConstants.spaceSmall),
                            // Changed alignment for LTR
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  AuthConstants.forgotPasswordText,
                                  style: TextStyle(color: AuthConstants.iconColor),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('signup'),
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              validator: (v) => (v == null || v.length < 3) ? AuthConstants.nameValidation : null,
                              decoration: _dec(AuthConstants.nameHint, icon: Icons.person_outline),
                            ),
                            const SizedBox(height: AuthConstants.spaceMedium),
                            TextFormField(
                              controller: emailCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              validator: (v) => (v == null || v.isEmpty) ? AuthConstants.emailValidation : null,
                              decoration: _dec(AuthConstants.emailHint, icon: Icons.alternate_email),
                            ),
                            const SizedBox(height: AuthConstants.spaceMedium),
                            TextFormField(
                              controller: passCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              obscureText: obscure,
                              validator: (v) => (v == null || v.length < 6) ? AuthConstants.passwordValidation : null,
                              decoration: _dec(AuthConstants.passwordHint, icon: Icons.lock_outline),
                            ),
                            const SizedBox(height: AuthConstants.spaceMedium),
                            TextFormField(
                              controller: confirmCtrl,
                              style: const TextStyle(color: AuthConstants.primaryTextColor),
                              obscureText: obscure,
                              validator: (v) => (v != passCtrl.text) ? AuthConstants.confirmPasswordValidation : null,
                              decoration: _dec(AuthConstants.confirmPasswordHint, icon: Icons.lock_reset_outlined),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AuthConstants.spaceLarge),
                _GradientButton(
                  text: isLogin ? AuthConstants.loginButtonText : AuthConstants.signupButtonText,
                  onTap: onSubmit,
                ),
                const SizedBox(height: AuthConstants.spaceMedium),
                const _DividerLabel(text: AuthConstants.dividerText),
                const SizedBox(height: AuthConstants.spaceMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _SocialIcon(label: AuthConstants.googleLabel, icon: Icons.g_mobiledata),
                    SizedBox(width: AuthConstants.spaceSocialIcons),
                    _SocialIcon(label: AuthConstants.appleLabel, icon: Icons.apple),
                  ],
                ),
                const SizedBox(height: AuthConstants.spaceMedium),
                const Text(
                  AuthConstants.policyText,
                  style: TextStyle(
                    color: AuthConstants.secondaryTextColor,
                    fontSize: AuthConstants.policyFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient Button with UI fix
class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AuthConstants.gradientColors),
        borderRadius: BorderRadius.circular(AuthConstants.inputBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: AuthConstants.gradientButtonShadowColor,
            blurRadius: AuthConstants.gradientButtonBoxShadowBlur,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AuthConstants.inputBorderRadius),
          onTap: onTap,
          child: SizedBox(
            height: AuthConstants.buttonHeight,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: AuthConstants.buttonTextColor,
                  fontWeight: AuthConstants.buttonFontWeight,
                  fontSize: AuthConstants.buttonFontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// All other helper widgets (_BackgroundBlobs, _Blob, _Segmented, _DividerLabel, _SocialIcon)
// can remain exactly the same as the previous version.
// For completeness, I'm including them here.

/// Background with gradient blobs
class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: AuthConstants.blobTopPosition,
          left: AuthConstants.blobLeftPosition,
          child: _Blob(
            size: AuthConstants.blobSize1,
            colors: AuthConstants.gradientColors,
          ),
        ),
        Positioned(
          bottom: AuthConstants.blobBottomPosition,
          right: AuthConstants.blobRightPosition,
          child: _Blob(
            size: AuthConstants.blobSize2,
            colors: AuthConstants.gradientColors.reversed.toList(),
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.colors});
  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors.map((c) => c.withAlpha(0.35.toAlpha())).toList(),
        ),
      ),
    );
  }
}

/// Segmented Control
class _Segmented extends StatelessWidget {
  const _Segmented(
      {required this.left,
      required this.right,
      required this.value,
      required this.onChanged});
  final String left;
  final String right;
  final bool value; // true => left
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AuthConstants.segmentedControlHeight,
      decoration: BoxDecoration(
        color: AuthConstants.inputFillColor,
        borderRadius:
            BorderRadius.circular(AuthConstants.segmentedControlBorderRadius),
        border: Border.all(color: AuthConstants.inputBorderColor),
      ),
      child: LayoutBuilder(
        builder: (_, c) => Stack(
          children: [
            AnimatedPositioned(
              duration: AuthConstants.segmentedControlDuration,
              curve: Curves.easeOut,
              left: value ? 0 : c.maxWidth / 2,
              right: value ? c.maxWidth / 2 : 0,
              child: Container(
                height: AuthConstants.segmentedControlHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      AuthConstants.segmentedControlBorderRadius - 2),
                  gradient:
                      const LinearGradient(colors: AuthConstants.gradientColors),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(true),
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          left,
                          style: TextStyle(
                              color: value ? Colors.black : Colors.white70,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(false),
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          right,
                          style: TextStyle(
                              color: value ? Colors.white70 : Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Divider with Label
class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AuthConstants.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AuthConstants.spaceSocialIcons),
          child: Text(text,
              style: const TextStyle(color: AuthConstants.secondaryTextColor)),
        ),
        const Expanded(child: Divider(color: AuthConstants.dividerColor)),
      ],
    );
  }
}

/// Social Media Icon
class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkResponse(
        onTap: () {},
        radius: AuthConstants.socialIconSize / 2,
        child: Container(
          width: AuthConstants.socialIconSize,
          height: AuthConstants.socialIconSize,
          decoration: BoxDecoration(
            color: AuthConstants.inputFillColor,
            borderRadius:
                BorderRadius.circular(AuthConstants.segmentedControlBorderRadius),
            border: Border.all(color: AuthConstants.inputBorderColor),
          ),
          child: Icon(icon, color: AuthConstants.primaryTextColor),
        ),
      ),
    );
  }
}