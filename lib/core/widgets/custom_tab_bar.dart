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
      backgroundColor: AppColors.barColor,
      title: Text(
        title!,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const CustomIcon(
            iconPath: "assets/icon/notification.svg",
            size: 22,
            color: AppColors.white,
          ),
          tooltip: 'notification',
          onPressed: () => context.push("/notification"),
        ),
        GestureDetector(
          onTap: () => context.push("/profile"),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            backgroundImage: userPhotoUrl.startsWith("http")
                ? NetworkImage(userPhotoUrl)
                : AssetImage(userPhotoUrl) as ImageProvider,
          ),
        ),
        const SizedBox(width: 10),
      ],
      bottom: TabBar(
          controller: tabController,
          labelColor: AppColors.blue,
          unselectedLabelColor: AppColors.white,
          indicatorColor: AppColors.blue,
          tabAlignment: TabAlignment.fill,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: AppColors.lessImportant,
          dividerHeight: 0.1,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          // indicatorSize: TabBarIndicatorSize.tab,
          tabs: tabs.map((tab) => Tab(text: tab)).toList()),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 48);
}
