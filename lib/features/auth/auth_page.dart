import 'package:flutter/material.dart';
import 'package:quickdrop_app/features/navigation/bottom_nav_bar.dart';
import 'package:quickdrop_app/features/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/features/models/user_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // bool _hasChangedTab = false;
  // bool _hasClearedUser = false;

  @override
  Widget build(BuildContext context) {
    // final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).user;

    if (user != null) {
      return LoginPage();
    } else {
      return const LoginPage();
    }
  }
}