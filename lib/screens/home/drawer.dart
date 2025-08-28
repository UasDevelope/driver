import 'package:driver/blocs/profile/profile_state.dart';
import 'package:driver/core/app_routes.dart';
import 'package:driver/repositories/auth_repository.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:driver/utils/const/toast_helper.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../services/local.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String profileImage;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthRepository _authRepository = AuthRepository();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(GetProfileEvent());
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen:
                (previous, current) =>
                    current is ProfileLoadingState || current is ProfileLoaded,
            builder: (BuildContext context, ProfileState state) {
              if (state is ProfileLoadingState) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: AppColor.appColor),
                    ),
                  ),
                );
              } else if (state is ProfileLoaded) {
                return DrawerHeader(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.appColor,
                        child: AppText(
                          text: state.profile.user.fullName[0].toLowerCase(),
                          color: AppColor.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 34,
                        ), // or use NetworkImage
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Welcome back,",
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          AppText(
                            text: state.profile.user.fullName,
                            color: AppColor.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          _buildDrawerItem(AppImages.clock, "Home", () {
            Navigator.pushNamed(context, AppRoutes.home);
          }),
          _buildDrawerItem(AppImages.clock, "Recent Orders", () {
            Navigator.pushNamed(context, AppRoutes.order);
          }),
          _buildDrawerItem(AppImages.earning, "Earnings", () {
            Navigator.pushNamed(context, AppRoutes.earning);
          }),
          // _buildDrawerItem(AppImages.notification, "Notifications", () {
          //   Navigator.pushNamed(context, AppRoutes.notification);
          // }),
          // _buildDrawerItem(AppImages.chat, "Messages", () {
          //   Navigator.pushNamed(context, AppRoutes.message);
          // }),
          // _buildDrawerItem(AppImages.setting, "Account Settings", () {
          //   Navigator.pushNamed(context, AppRoutes.settings);
          // }),
          _buildDrawerItem(AppImages.reviewimg, "Reviews & Ratings", () {
            Navigator.pushNamed(context, AppRoutes.review);
          }),

          const Spacer(),
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppColor.red),
            title: _isDeleting
                ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.red),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        text: "Deleting...",
                        color: AppColor.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ],
                  )
                : AppText(
                    text: "Delete Account",
                    color: AppColor.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
            onTap: _isDeleting ? null : _showDeleteAccountDialog,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColor.red),
            title: AppText(
              text: "Log out",
              color: AppColor.red,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            onTap: () async {
              await LocalStorage.storeString(LocalStorage.AcessToken, '');
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );

            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(icon, height: 30, width: 30, color: AppColor.black),
      title: AppText(
        text: title,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColor.black,
      ),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: AppColor.red, size: 28),
              const SizedBox(width: 8),
              AppText(
                text: "Delete Account",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          content: AppText(
            text: "Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data.",
            fontSize: 14,
            color: AppColor.grey,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: "Cancel",
                color: AppColor.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: "Delete",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await _authRepository.deleteAccount();
      
      ToastHelper.showToast(message: "Account deleted successfully");
      
      // Navigate to login screen and clear all routes
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
        
        ToastHelper.showToast(message: e.toString());
      }
    }
  }
}
