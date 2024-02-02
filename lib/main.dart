//main.dart
import 'package:firebase_project/screens/auth_stl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:firebase_project/screens/splash.dart';
import 'package:firebase_project/screens/chat.dart';
// import 'firebase_options.dart';
import 'package:firebase_project/screens/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_project/service/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => LoginState(),
    child: App()
  ),);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const SplashScreen();
            // }

            if (snapshot.hasData) {
              return const ChatScreen();
            }

            return AuthScreen();
          }),
    );
  }
}