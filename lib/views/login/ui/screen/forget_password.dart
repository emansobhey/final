// file: reset_password.dart
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/button.dart';
import 'package:gradprj/core/widgets/text_form_field.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            verticalSpace(30),
            const MyTextFormField(
              hint: "Enter your email",
              isObecure: false,
              prefixIcon: Icon(Icons.email, color: MyColors.fontColor),
            ),
            verticalSpace(30),
            RaisedGradientButton(
              width: double.infinity,
              gradient: const LinearGradient(
                colors: <Color>[
                  MyColors.button1Color,
                  MyColors.button2Color,
                ],
              ),
              onPressed: () {
                // simulate email sent
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: MyColors.backgroundColor,
                    title: const Text(
                      "Check your email!",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      "We've sent you instructions to reset your password.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK",
                            style: TextStyle(color: MyColors.txt2Color)),
                      )
                    ],
                  ),
                );
              },
              child: Text(
                'SEND RESET LINK',
                style: MyFontStyle.font12RegularBtn
                    .copyWith(color: MyColors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
