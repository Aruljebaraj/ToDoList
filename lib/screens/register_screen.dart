import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final provider = Provider.of<AuthProvider>(context);
    return StreamBuilder<User?>(
      stream: provider.stream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ))
            },
          )
              //  title: const Text("Register Account"),
              ),
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
                          decoration:
                              const InputDecoration(label: Text('E-mail')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: password,
                          obscureText: provider.obscureText,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffix: IconButton(
                              onPressed: () {
                                provider.toggle();
                              },
                              icon: Icon(
                                provider.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: provider.obscureText
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
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
                                provider.signUpPressed(
                                  email.text,
                                  password.text,
                                  context,
                                );
                                // email.clear();
                                // password.clear();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(
                                  5,
                                ),
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
