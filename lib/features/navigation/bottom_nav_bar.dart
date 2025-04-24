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


class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    const HomeScreen(),
    const TripScreen(),
    const ShipmentScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    
     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.cardBackground, // Set the color of the phone's bottom bar
      systemNavigationBarIconBrightness: Brightness.light, // Make icons light if the background is dark
    ));
    return Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
      return Scaffold(
          body: _pages[navigationProvider.currentIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: AppColors.cardBackground, // ✅ Removes white ripple effect
              highlightColor: AppColors.cardBackground, // ✅ Disables highlight animation
            ),
            child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationProvider._currentIndex,
            onTap: (index) => navigationProvider.changeTab(index),
            showSelectedLabels: true,
            selectedItemColor: AppColors.blue,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            backgroundColor: AppColors.cardBackground,
            unselectedItemColor: AppColors.lessImportant,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/magnifer.svg",
                  isSelected: navigationProvider.currentIndex == 0,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/trip.svg",
                  isSelected: navigationProvider.currentIndex == 1,
                ),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/package.svg",
                  isSelected: navigationProvider.currentIndex == 2,
                ),
                label: 'Shipment',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/chat-round.svg",
                  isSelected: navigationProvider.currentIndex == 3,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: _buildIconWithBackground(
                  iconPath: "assets/icon/user.svg",
                  isSelected: navigationProvider.currentIndex == 4,
                ),
                label: 'Profile',
              ),
            ],
          ),
      ));
    });
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
}
