import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class SplashRedirect extends StatefulWidget {
  const SplashRedirect({super.key});

  @override
  State<SplashRedirect> createState() => _SplashRedirectState();
}

class _SplashRedirectState extends State<SplashRedirect> {
  @override
  void initState() {
    super.initState();
    // Defer navigation until after the first frame to ensure the GoRouter  is available on the widget tree. Calling context.go() directly in  initState can sometimes fail if the router isn't yet ready.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkRoute();
    });
  }

  Future<void> _checkRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = await AuthService.isLoggedIn();

    if (user != null) {
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUser(user.uid);
    }

    // await Future.delayed(const Duration(milliseconds: 100));
    if (isLoggedIn) {
      context.go('/home');
      return;
    }

    if (!seen) {
      context.go('/onboarding');
      return;
    }
    context.go('/intro');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background, body: loadingAnimation());
  }
}
