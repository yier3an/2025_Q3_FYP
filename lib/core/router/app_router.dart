import 'package:go_router/go_router.dart';
import 'package:my_website/core/features/presentation/pages/home_page.dart';
import 'package:my_website/core/features/presentation/pages/signup_page.dart';
import 'package:my_website/core/features/presentation/pages/verify_email_page.dart';
import 'package:my_website/core/features/presentation/pages/welcome_download_page.dart';
import 'package:my_website/core/features/presentation/pages/login_page.dart';

var router = GoRouter(
  routes: [
    GoRoute(
      path: HomePage.path,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: SignUpPage.path,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: VerifyEmailPage.path,
      builder: (context, state) => const VerifyEmailPage(),
    ),
    GoRoute(
      path: WelcomeDownloadPage.path,
      builder: (context, state) => const WelcomeDownloadPage(),
    ),
    GoRoute(
      path: LoginPage.path,
      builder: (context, state) => const LoginPage(),
    )
  ],
  initialLocation: HomePage.path,
);
