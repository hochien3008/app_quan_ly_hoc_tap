import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool floating;
  final bool pinned;
  final bool snap;
  final Widget? flexibleSpace;
  final double expandedHeight;

  const AppSliverAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.flexibleSpace,
    this.expandedHeight = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      elevation: elevation,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      flexibleSpace: flexibleSpace ?? _buildDefaultFlexibleSpace(context),
      actions: actions,
    );
  }

  Widget _buildDefaultFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Text(
          title,
          style: TextStyle(
            color: foregroundColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor ?? AppColors.primary,
              (backgroundColor ?? AppColors.primary).withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget helper để tạo SliverAppBar với FlexibleSpaceBar tùy chỉnh
class CustomFlexibleSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? background;
  final double expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFlexibleSliverAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.background,
    this.expandedHeight = 120,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      elevation: elevation,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            title,
            style: TextStyle(
              color: foregroundColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        background:
            background ??
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundColor ?? AppColors.primary,
                    (backgroundColor ?? AppColors.primary).withOpacity(0.8),
                  ],
                ),
              ),
            ),
      ),
      actions: actions,
    );
  }
}
