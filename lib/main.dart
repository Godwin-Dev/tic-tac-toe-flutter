import 'package:exoh/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentTheme;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    currentTheme = prefs.getString("theme") ?? "light";
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  changeTheme() {
    setState(() {
      currentTheme = currentTheme == "light" ? "dark" : "light";
    });
    saveTheme();
  }

  saveTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", currentTheme);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: currentTheme == "light" ? ThemeData.light().copyWith(
        primaryColor: Colors.cyan,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.cyan[500],
        ),
      ) : ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[900],
        ),
      ),
      home: Home(currentTheme, changeTheme),
    );
  }
}
