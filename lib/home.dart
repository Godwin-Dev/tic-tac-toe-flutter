import 'package:exoh/game_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String currentTheme;
  final Function changeTheme;

  Home(this.currentTheme, this.changeTheme);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: currentTheme == "light"
            ? Icon(Icons.brightness_2)
            : Icon(Icons.wb_sunny),
        onPressed: changeTheme,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/$currentTheme full.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(
                      mode: "solo",
                      theme: currentTheme,
                    ),
                  ),
                );
              },
              color: currentTheme == "dark"
                  ? Colors.green[700]
                  : Colors.blueGrey[400],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "    SOLO    ",
                  style: TextStyle(fontSize: 24.0, color: currentTheme == "dark" ? Colors.white70 : Colors.black54),
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(
                      mode: "duo",
                      theme: currentTheme,
                    ),
                  ),
                );
              },
              color:
                  currentTheme == "dark" ? Colors.red[900] : Colors.cyan[400],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "    DUO    ",
                  style: TextStyle(fontSize: 24.0, color: currentTheme == "dark" ? Colors.white70 : Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
