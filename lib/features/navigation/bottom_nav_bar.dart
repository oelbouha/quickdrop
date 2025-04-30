import 'package:flutter/material.dart';
import 'package:quickdrop_app/features/chat/chat_screen.dart';
import 'package:quickdrop_app/features/home/home_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/features/shipment/shipment_screen.dart';
import 'package:quickdrop_app/features/trip/trip_screen.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class BottomNavScreen extends StatelessWidget {
  int _curentIndex = 0;
  final Widget child;
  BottomNavScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor:
    //       AppColors.cardBackground, // Set the color of the phone's bottom bar
    //   systemNavigationBarIconBrightness:
    //       Brightness.light, // Make icons light if the background is dark
    // ));
    return Scaffold(
        body: child,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor:
                AppColors.cardBackground, // ✅ Removes white ripple effect
            highlightColor:
                AppColors.cardBackground, // ✅ Disables highlight animation
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _calculateIndex(context),
            onTap: (index) => _onTap(index, context),
            showSelectedLabels: true,
            selectedItemColor: AppColors.blue,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle:
                const TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),
            backgroundColor: AppColors.cardBackground,
            unselectedItemColor: AppColors.lessImportant,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/magnifer.svg",
                  isSelected: _calculateIndex(context) == 0,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/car.svg",
                  isSelected: _calculateIndex(context) == 1,
                ),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/package.svg",
                  isSelected: _calculateIndex(context) == 2,
                ),
                label: 'Shipment',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/chat-round.svg",
                  isSelected: _calculateIndex(context) == 3,
                ),
                label: 'Chat',
              ),
              // BottomNavigationBarItem(
              //   icon: _buildIconWithBackground(
              //     iconPath: "assets/icon/user.svg",
              //     isSelected: navigationProvider.currentIndex == 4,
              //   ),
              //   label: 'Profile',
              // ),
            ],
          ),
        ));
  }

  Widget _buildIconWithBackground({
    required String iconPath,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: 60,
      height: 30,
      decoration: BoxDecoration(
          color:
              isSelected ? AppColors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20)),
      child: CustomIcon(
        iconPath: iconPath,
        size: 24,
        color: isSelected ? AppColors.blue : AppColors.lessImportant,
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri;
    if (location.path == '/trip')  return 1;
    if (location.path == "/shipment") return 2;
    if (location.path == '/chat') return 3;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/trip');
        break;
      case 2:
        context.go('/shipment');
        break;
      case 3:
        context.go('/chat');
        break;
    }
  }
}
