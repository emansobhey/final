import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/app_bar.dart';
import 'package:gradprj/core/helpers/custom_raised_gradientbutton.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/text_form_field.dart';
import 'package:gradprj/views/login/ui/widgets/do_not_have_an_account.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarOfSpokify(),
            verticalSpace(100),
            Text(
              "Welcome",
              style: MyFontStyle.font45Regular
                  .copyWith(color: MyColors.whiteColor, height: 1.0),
            ),
            Text("Back!",
                style: MyFontStyle.font45Bold
                    .copyWith(color: MyColors.txt1Color, height: 1.0)),
            verticalSpace(20),
            const MyTextFormField(
              hint: "Email Address",
              isObecure: false,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(20),
            const MyTextFormField(
              hint: "Password",
              isObecure: false,
              prefixIcon: Icon(Icons.lock, color: MyColors.fontColor),
              suffixIcon: Icon(
                Icons.visibility,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(30),
            CustomRaisedGradientButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.singUp);
                },
                width: 350,
                text: 'LOG IN'),
            verticalSpace(20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.forget_password);
              },
              child: Text(
                "Forgot Password?",
                style: MyFontStyle.font11RegularUnderline.copyWith(
                    color: MyColors.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: MyColors.whiteColor),
              ),
            ),
            verticalSpace(10),
            const DonotHaveAnAccountRow()
          ],
        ),
      )),
    );
  }
}
