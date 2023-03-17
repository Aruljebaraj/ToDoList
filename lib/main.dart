import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/auth_provider.dart';
import 'package:todolist/provider/todo_list_provider.dart';
import 'package:todolist/screens/add_todo.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
        StreamProvider(
            create: (context) => context.watch<AuthProvider>().stream(),
            initialData: null),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark(),
        home:LoginScreen(),
      ),
    );
  }
}
