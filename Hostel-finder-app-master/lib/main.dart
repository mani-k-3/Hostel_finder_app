import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/home.dart';
import 'package:hostel_app/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HostelFinderApp());
}

class HostelFinderApp extends StatelessWidget {
  const HostelFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner:false,
      home:LoginScreen(),
    );
  }
}
