import 'package:cv_manager/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'features/auth/screens/splash_screen.dart'; 
import 'features/auth/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
     
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Manager',
    theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, 
        primaryColor: Colors.cyanAccent.shade700,
        scaffoldBackgroundColor: const Color(0xFF0F2027), 
        
      

       
       
      ),
      
      home: const SplashScreen(), 
    );
  }
}
    
 

