import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final bool useGradient;
  final bool useGlass;
  final Widget? profileAvatar;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false, // Mặc định false để title nằm bên trái
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.useGradient = false,
    this.useGlass = false,
    this.profileAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mainColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;
    final Color textColor = foregroundColor ?? Colors.white;
    final Color iconColor = Colors.white; // Icon màu trắng

    return Container(
      decoration: BoxDecoration(
        gradient:
            useGradient
                ? LinearGradient(
                  colors: [mainColor, mainColor.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                : null,
        color: useGradient ? null : mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow:
            elevation > 0
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(color: iconColor),
                  child: leading!,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child:
                    centerTitle
                        ? Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ), // Thêm padding để không quá sát
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
              ),
              if (actions != null) ...[
                ...actions!.map(
                  (action) => IconTheme(
                    data: IconThemeData(color: iconColor),
                    child: action,
                  ),
                ),
                if (profileAvatar != null) const SizedBox(width: 8),
              ],
              if (profileAvatar != null) profileAvatar!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool floating;
  final bool pinned;
  final bool snap;
  final Widget? flexibleSpace;

  const CustomSliverAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.flexibleSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor ?? Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      floating: floating,
      pinned: pinned,
      snap: snap,
      flexibleSpace: flexibleSpace,
    );
  }
}
