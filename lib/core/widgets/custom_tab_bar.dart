import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

TabBar customTabBar(
    {
      required TabController tabController,
      required List<String> tabs
    }
    ){


    return TabBar(
      controller: tabController,
      labelColor: AppColors.blue,
      unselectedLabelColor: AppColors.white,
      indicatorColor: AppColors.blue,
      tabAlignment: TabAlignment.fill,
      indicatorWeight: 2,
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
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: tabs.map((tab) => Tab(text: tab)).toList()
    );
  }

