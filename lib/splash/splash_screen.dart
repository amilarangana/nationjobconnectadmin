import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/authentication/screens/signin_screen.dart';
import 'package:nation_job_connect_admin/resources/colors.dart';
import '../authentication/store_credentials/auth_shared_prefs.dart';
import '/base/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authShredPrefs = AuthSharedPrefs();
    
  void proceedToNext() {
    Timer(const Duration(seconds: 3), () {
      // Navigator.of(context).pop();
      var user = _authShredPrefs.retrieveSavedUserCredentials();
      if (user != null) {
         Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const MainScreen(
                key: Key("main_screen"),
              )));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => SigninScreen(
                key: const Key("signin_screen"),
              )));
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    proceedToNext();
    return Scaffold(
      backgroundColor: const Color(ResColors.colorPrimary),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xff3D3D3D), Color(ResColors.colorPrimary)]),
        ),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: const Stack(
          children: [
            Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: Text("Nation Job Connect", style: TextStyle(color: Color(ResColors.colorFontSplash)),))),
          ],
        ),
      ),
    );
  }
}
