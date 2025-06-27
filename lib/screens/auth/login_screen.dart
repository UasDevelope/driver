import 'dart:developer';

import 'package:driver/screens/order_detail/order_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/authentication/auth_bloc.dart';
import '../../blocs/authentication/auth_state.dart';
import '../../core/app_routes.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../utils/const/app_string.dart';
import '../../utils/const/toast_helper.dart';
import '../../utils/validator.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';

import '../../blocs/authentication/auth_event.dart';
import '../review_screen/review_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(color: AppColor.appColor)),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            _showLoadingDialog();
          } else {
            _hideLoadingDialog();
            if (state is AuthErrorState) {
              ToastHelper.showToast(message: state.message, type: ToastType.error);
            } else if (state is AuthSuccessState) {
              Navigator.pushNamed(context, AppRoutes.loginSucess);
              ToastHelper.showToast(
                message: state.message,
                type: ToastType.success,
              );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isChecked = state is RememberChecked ? state.isRememberMeChecked : false;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(AppImages.logo, height: 200, width: 200),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: AppText(
                        text: AppStrings.welcomeBack,
                        color: AppColor.blue,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: AppText(
                        text: AppStrings.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColor.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppText(
                      text: AppStrings.emailOrPhone,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                    const SizedBox(height: 10),
                    AppTextFormField(
                      controller: emailController,
                      backgroundColor: const Color(0xffF8F7FB),
                      hintColor: AppColor.grey,
                      hintText: AppStrings.enterEmail,
                      preficColor: AppColor.blue,
                      prefixIcon: AppImages.email,
                      validator: AppValidators.emailValidate,
                    ),
                    const SizedBox(height: 30),
                    AppText(
                      text: AppStrings.password,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                    const SizedBox(height: 10),
                    AppTextFormField(
                      controller: passwordController,
                      backgroundColor: const Color(0xffF8F7FB),
                      hintColor: AppColor.grey,
                      hintText: AppStrings.enterPassword,
                      preficColor: AppColor.blue,
                      prefixIcon: AppImages.email,
                      isPassword: true,
                      validator: AppValidators.passwordValidate,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            log("CHecking");
                            context.read<AuthBloc>().add(
                              CheckboxToggled(isChecked: value!),
                            );
                          },
                        ),
                        AppText(text: AppStrings.rememberMe),
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          child: AppText(
                            text: AppStrings.forgotPassword,
                            color: AppColor.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    AppButton(
                      backgroundColor: AppColor.appColor,
                      borderRadius: 10,
                      text: AppStrings.login,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            LoginRequest(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(text: AppStrings.dontHaveAccount),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          child: AppText(
                            text: AppStrings.signUpHere,
                            color: AppColor.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
