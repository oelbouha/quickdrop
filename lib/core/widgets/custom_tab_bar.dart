import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/build_header_icon.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final TabController tabController;
  final List tabs;
  final String? title;
  final bool expanded;
  const CustomAppBar({
    super.key,
    required this.tabController,
    this.expanded = true,
    required this.tabs,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),  
      curve: Curves.easeOut,
      height: expanded ? kToolbarHeight + 80 : 100,
      child: AppBar(
      backgroundColor: AppColors.appBarBackground,
       title:   expanded
          ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  color: AppColors.appBarText,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
             const  Row(
          children: [
            // buildHeaderIcon(
            //   icon: "assets/icon/help.svg",
            //   onTap: () => context.push("/help"),
            // ),
            // const SizedBox(width: 8),
            NotificationIcon(),
          ],
        ),
            ],
          )
        : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child:  AnimatedSlide(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            offset: expanded ? Offset.zero : const Offset(0, -0.1),
            
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.tabTextActive,
            unselectedLabelColor: AppColors.tabTextInactive,
            indicatorColor: AppColors.blueStart,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: AppColors.lessImportant,
            dividerHeight: 0.4,
            isScrollable: tabs.length > 3,
            tabAlignment: tabs.length > 3 ? TabAlignment.start : TabAlignment.fill, 
            padding: tabs.length > 3 ? const EdgeInsets.symmetric(horizontal: 16) : null, 
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
    ));
  }




  @override
  Size get preferredSize => Size.fromHeight(expanded ? kToolbarHeight + 48: 48);
}
