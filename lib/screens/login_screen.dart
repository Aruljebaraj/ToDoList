import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/register_screen.dart';

import '../provider/auth_provider.dart';
import 'home_screen.dart';

final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final provider = Provider.of<AuthProvider>(context);

    return StreamBuilder(
      stream: provider.stream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/logo.png",
                          height: 150,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: const InputDecoration(
                              label: Text('Enter e-mail')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, value, child) {
                            return TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: password,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      value.toggle();
                                    },
                                    icon: Icon(
                                      value.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: value.obscureText
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                    splashRadius: 20,
                                  ),
                                  label: const Text('Enter Password')),
                              obscureText: value.obscureText,
                            );
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Have no account ? ',
                                ),
                                Text('Register',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900))
                              ],
                            )
                            // TextButton(
                            //   onPressed: () {},
                            //   child: const Text(
                            //     "Forgot Password?",
                            //    // style: textStyel,
                            //   ),
                            // ),

                            ),
                        if (provider.isLoading)
                          const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        if (!provider.isLoading)
                          SizedBox(
                            width: double.maxFinite,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                provider.signInPressed(
                                  email.text,
                                  password.text,
                                  context,
                                );
                                email.clear();
                                password.clear();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(
                                  5,
                                ),
                              ),
                              child: const Text('Sign In'),
                            ),
                          ),
                      ]),
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}
