import 'package:driver/screens/auth/otp_screen.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:flutter/material.dart';

import '../../utils/const/app_color.dart';
import '../../utils/const/app_string.dart';
import '../../utils/validator.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';
class ForgetPasswordScreen extends StatelessWidget {
 ForgetPasswordScreen({super.key});
  final emailController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
            Center(child: Image.asset(AppImages.logo,height: 53,width: 56,)),
              SizedBox(height: 20,),
                Center(
          child: AppText(
            text: AppStrings.resetPasswordH,
            color: AppColor.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),),
                Center(
          child: AppText(
            text: AppStrings.resetPasswordB,
            color: AppColor.light_black2,
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
          ),),
              SizedBox(height: 30,),
              Center(child: Image.asset(AppImages.resetImage,height: 250,)),
              const SizedBox(height: 10),
              AppText(
                text: AppStrings.email,
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
              const SizedBox(height: 20),
              AppButton(
                backgroundColor: AppColor.appColor,
                borderRadius: 10,
                text: AppStrings.sendVFCode,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(),));
                },
              ),
              SizedBox(height: 8,),
              AppButton(
                backgroundColor: AppColor.grey,
                borderRadius: 10,
                text: "BACK TO LOGIN",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
          ],),
        ),
      ),
    );
  }
}
