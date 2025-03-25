import 'package:expense_tracker/viewmodels/auth/auth_viewmodel.dart';
import 'package:expense_tracker/viewmodels/expense/expense_viewmodel.dart';
import 'package:expense_tracker/viewmodels/home/home_viewmodel.dart';
import 'package:expense_tracker/viewmodels/profile/profile_viewmodel.dart';
import 'package:expense_tracker/views/screens/home/home_screen.dart';
import 'package:expense_tracker/views/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBnjD-Uk6SmG7wlKCBMzZvV7Qmdu761idM",
      appId: "1:123945076529:android:a2b0a3c9cc806a33a65210",
      messagingSenderId: "123945076529",
      projectId: "expense-tracker-5ee41",
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CipherX',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return FutureBuilder<bool>(
            future: authViewModel.isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final bool isLoggedIn = snapshot.data ?? false;
              return isLoggedIn ? const HomeScreen() : const LoginScreen();
            },
          );
        },
      ),
    );
  }
}
