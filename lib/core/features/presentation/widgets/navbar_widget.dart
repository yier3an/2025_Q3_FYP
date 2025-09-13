import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_website/core/theme/app_color.dart';
import 'package:my_website/core/utils/context_utils.dart';
import 'package:my_website/core/features/presentation/widgets/logo_widget.dart';

// for paths
import 'package:my_website/core/features/presentation/pages/home_page.dart';
import 'package:my_website/core/features/presentation/pages/login_page.dart';

class NavbarWidget extends StatelessWidget {
  // Callbacks used only when we're already on /home to scroll to sections
  final VoidCallback? onHomePressed;
  final VoidCallback? onFeaturesPressed;
  final VoidCallback? onScreenshotsPressed;
  final VoidCallback? onFaqPressed;
  final VoidCallback? onPricingPressed;
  final VoidCallback? onContactPressed;

  // Optional override for Login click
  final VoidCallback? onLoginPressed;

  const NavbarWidget({
    super.key,
    this.onHomePressed,
    this.onFeaturesPressed,
    this.onScreenshotsPressed,
    this.onFaqPressed,
    this.onPricingPressed,
    this.onContactPressed,
    this.onLoginPressed,
  });

  // --- Helpers ---------------------------------------------------------------

  bool _isOnHome(BuildContext context) {
    final loc = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    return loc.contains(HomePage.path);
  }

  /// If already on /home -> run the provided scroll callback.
  /// Otherwise navigate to /home#<fragment>.
  void _goOrScroll(
    BuildContext context, {
    required String fragment,
    VoidCallback? scrollCallback,
  }) {
    if (_isOnHome(context)) {
      scrollCallback?.call();
    } else {
      final dest =
          fragment.isEmpty ? HomePage.path : '${HomePage.path}#$fragment';
      context.go(dest);
    }
  }

  // --- Build ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(80),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 980 || context.isMobile;
          return isCompact
              ? _buildMobileNavbar(context)
              : _buildDesktopNavbar(context);
        },
      ),
    );
  }

  // -------------------- Desktop --------------------

  Widget _buildDesktopNavbar(BuildContext context) {
    return Row(
      children: [
        const LogoWidget(),
        const Spacer(),

        Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _link('Home', () => _goOrScroll(
                  context,
                  fragment: '',
                  scrollCallback: onHomePressed,
                )),
            _link('Features', () => _goOrScroll(
                  context,
                  fragment: 'features',
                  scrollCallback: onFeaturesPressed,
                )),
            _link('Screenshots', () => _goOrScroll(
                  context,
                  fragment: 'screenshots',
                  scrollCallback: onScreenshotsPressed,
                )),
            _link('FAQ', () => _goOrScroll(
                  context,
                  fragment: 'faq',
                  scrollCallback: onFaqPressed,
                )),
            _link('Pricing', () => _goOrScroll(
                  context,
                  fragment: 'pricing',
                  scrollCallback: onPricingPressed,
                )),
            _link('Contact', () => _goOrScroll(
                  context,
                  fragment: 'contact',
                  scrollCallback: onContactPressed,
                )),
          ],
        ),
        const SizedBox(width: 24),

        _loginButton(
          onTap: onLoginPressed ?? () => context.go(LoginPage.path),
        ),
      ],
    );
  }

  // -------------------- Mobile --------------------

  Widget _buildMobileNavbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const LogoWidget(),
        Row(
          children: [
            _loginButton(
              compact: true,
              onTap: onLoginPressed ?? () => context.go(LoginPage.path),
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showMobileMenu(context),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------- Shared pieces --------------------

  Widget _link(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  // Note: no BuildContext param here anymore
  Widget _loginButton({
    VoidCallback? onTap,
    bool compact = false,
  }) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF6C4DFF),
        foregroundColor: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: compact ? 14 : 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text('Login'),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primary.withOpacity(0.96),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _mobileItem(sheetCtx, 'Home', () => _goOrScroll(
                      sheetCtx,
                      fragment: '',
                      scrollCallback: onHomePressed,
                    )),
                _mobileItem(sheetCtx, 'Features', () => _goOrScroll(
                      sheetCtx,
                      fragment: 'features',
                      scrollCallback: onFeaturesPressed,
                    )),
                _mobileItem(sheetCtx, 'Screenshots', () => _goOrScroll(
                      sheetCtx,
                      fragment: 'screenshots',
                      scrollCallback: onScreenshotsPressed,
                    )),
                _mobileItem(sheetCtx, 'FAQ', () => _goOrScroll(
                      sheetCtx,
                      fragment: 'faq',
                      scrollCallback: onFaqPressed,
                    )),
                _mobileItem(sheetCtx, 'Pricing', () => _goOrScroll(
                      sheetCtx,
                      fragment: 'pricing',
                      scrollCallback: onPricingPressed,
                    )),
                _mobileItem(sheetCtx, 'Contact', () => _goOrScroll(
                      sheetCtx,
                      fragment: 'contact',
                      scrollCallback: onContactPressed,
                    )),
                const SizedBox(height: 8),
                _loginButton(
                  onTap: onLoginPressed ?? () {
                    Navigator.pop(sheetCtx); // close the sheet
                    sheetCtx.go(LoginPage.path);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mobileItem(BuildContext ctx, String title, VoidCallback onTap) {
    return ListTile(
      title: Center(
        child: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      onTap: () {
        Navigator.pop(ctx); // close the sheet
        onTap();
      },
    );
  }
}
