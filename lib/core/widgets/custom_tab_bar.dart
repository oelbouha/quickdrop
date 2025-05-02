import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userPhotoUrl;
  final TabController tabController;
  final List<String> tabs;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.userPhotoUrl,
    required this.tabController,
    required this.tabs,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      title: Text(
        title!,
        style: const TextStyle(
          color: AppColors.appBarText,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const CustomIcon(
            iconPath: "assets/icon/notification.svg",
            size: 22,
            color: AppColors.appBarIcons,
          ),
          tooltip: 'notification',
          onPressed: () => context.push("/notification"),
        ),
        GestureDetector(
          onTap: () => context.push("/profile"),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.blue,
            backgroundImage: userPhotoUrl.startsWith("http")
                ? NetworkImage(userPhotoUrl)
                : AssetImage(userPhotoUrl) as ImageProvider,
          ),
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: AppColors.background,
        child: TabBar(
          controller: tabController,
          labelColor: AppColors.tabTextActive,
          unselectedLabelColor: AppColors.tabTextInactive,
          indicatorColor: AppColors.tabIndicator,
          tabAlignment: TabAlignment.fill,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: AppColors.lessImportant,
          dividerHeight: 0.2,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
    ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 48);
}
