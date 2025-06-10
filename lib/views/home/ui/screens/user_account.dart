import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/views/home/ui/widgets/imageCircleAvatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showEditFields = false;
  bool isDark = true;

  final TextEditingController nameController =
  TextEditingController(text: "Shrouk Ahmed");
  final TextEditingController emailController =
  TextEditingController(text: "Shrouk_Ahmed9@gmail.com");
  final TextEditingController passwordController =
  TextEditingController(text: "s1234567");

  String displayedName = "Shrouk Ahmed";
  String displayedEmail = "Shrouk_Ahmed9@gmail.com";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: MyColors.backgroundColor,
        displayColor: MyColors.backgroundColor,
      ),
    );

    final ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: MyColors.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.backgroundColor,
        foregroundColor: Colors.white,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );

    return Theme(
      data: isDark ? darkTheme : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/images/arrow.png",
              width: 24,
              height: 24,
            ),
          ),
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                verticalSpace(20),
                const ImageCircleAvatar(userName: 'shro',),
                const SizedBox(height: 10),
                Text(
                  displayedName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(displayedEmail),
                const SizedBox(height: 20),

                /// Edit Profile section
                ListTile(
                  leading:
                  const Icon(Icons.edit, color: MyColors.button1Color),
                  title: const Text('Edit Profile'),
                  trailing: Icon(
                    showEditFields
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onTap: () {
                    setState(() {
                      showEditFields = !showEditFields;
                    });
                  },
                ),
                if (showEditFields) ...[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        displayedName = nameController.text;
                        displayedEmail = emailController.text;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings,
                      color: MyColors.button1Color),
                  title: const Text('Mode'),
                  subtitle: const Text('Dark & Light'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                      });
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.help,
                    color: MyColors.button1Color,
                  ),
                  title: const Text('About'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.about);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out')),
                    );
                  },
                  icon: Transform.rotate(
                    angle: 3.1416, // π radians = 180 degrees
                    child: const Icon(
                      Icons.logout,
                      color: MyColors.button1Color,
                      size: 25,
                    ),
                  ),
                  label: const Text('Sign Out',
                      style: TextStyle(
                          color: MyColors.button1Color, fontSize: 20)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
