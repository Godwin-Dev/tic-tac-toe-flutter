import 'dart:async';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String mode;
  final String theme;

  GamePage({this.mode, this.theme});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int move = 1;
  bool isGameOver = false;
  bool isEngaged = false;
  List boardValues = ["", "", "", "", "", "", "", "", ""];
  List boardMatrix = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""]
  ];

  void restartGame() {
    setState(() {
      move = 1;
      isEngaged = false;
      isGameOver = false;
      boardValues = ["", "", "", "", "", "", "", "", ""];
      boardMatrix = [
        ["", "", ""],
        ["", "", ""],
        ["", "", ""]
      ];
    });
  }

  void displayResult(bool gameOver, int player) {
    if (gameOver == true && [1, 2].contains(player)) {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Hurray!'),
          content: Text('Player $player has won the game.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(
                    restartGame()); // dismisses only the dialog and returns nothing
              },
              child: new Text(
                'RESTART',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    } else if (move >= 9) {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Hehe...'),
          content: Text("It's a Tie"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(
                    restartGame()); // dismisses only the dialog and returns nothing
              },
              child: new Text(
                'PLAY AGAIN',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }
  }

  List bestMove() {
    var bestScore = -10; /*INSTEAD OF NEGATIVE INFINITY */
    var index;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (boardMatrix[i][j] == "") {
          boardMatrix[i][j] = "O";
          move += 1;
          int score = miniMax(0, false);
          boardMatrix[i][j] = "";
          move -= 1;
          if (score > bestScore) {
            bestScore = score;
            index = [i, j];
          }
        }
      }
    }
    return index;
  }

  var scores = {
    1: -10,
    2: 10,
    3: 0,
  };

  int miniMax(depth, bool isMaximizing) {
    var result = validate(boardMatrix);
    if (result[0] == true) {
      int score = scores[result[1]];
      return score;
    }
    if (isMaximizing) {
      var bestScore = -10; /*INSTEAD OF NEGATIVE INFINITY */
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (boardMatrix[i][j] == "") {
            boardMatrix[i][j] = "O";
            move += 1;
            int score = miniMax(depth + 1, false);
            boardMatrix[i][j] = "";
            move -= 1;
            bestScore = score > bestScore ? score : bestScore;
          }
        }
      }
      return bestScore;
    } else {
      var bestScore = 10; /*INSTEAD OF INFINITY */
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (boardMatrix[i][j] == "") {
            boardMatrix[i][j] = "X";
            move += 1;
            int score = miniMax(depth + 1, true);
            boardMatrix[i][j] = "";
            move -= 1;
            bestScore = score < bestScore ? score : bestScore;
          }
        }
      }
      return bestScore;
    }
  }

  void changeBoardValue(int index) {
    var result;
    setState(() {
      boardMatrix[index ~/ 3][index % 3] = move % 2 != 0 ? "X" : "O";
    });
    result = validate(boardMatrix);
    if (result[0] == true) {
      isGameOver = true;
      displayResult(result[0], result[1]);
    }

    if (widget.mode == "solo" && move % 2 != 0 && isGameOver == false) {
      setState(() {
        isEngaged = true;
      });
      List index = bestMove();
      Timer(Duration(seconds: 1), () {
        setState(() {
          isEngaged = false;
          boardMatrix[index[0]][index[1]] = "O";
          result = validate(boardMatrix);
          if (result[0] == true) {
            displayResult(result[0], result[1]);
          }
          move += 1;
        });
      });
    }
    if (move == 9 && isGameOver == false) {
      displayResult(result[0], result[1]);
    }
  }

  List validate(List matrix) {
    // Checking horizontal
    for (List row in matrix) {
      if (row[0] == "X" && row[1] == "X" && row[2] == "X") {
        return [true, 1];
      } else if (row[0] == "O" && row[1] == "O" && row[2] == "O") {
        return [true, 2];
      }
    }

    //Checking vertical
    for (int i = 0; i < 3; i++) {
      List row = [];
      for (int j = 0; j < 3; j++) {
        row.add(matrix[j][i]);
      }
      if (row[0] == "X" && row[1] == "X" && row[2] == "X") {
        return [true, 1];
      } else if (row[0] == "O" && row[1] == "O" && row[2] == "O") {
        return [true, 2];
      }

      //Checking diagonally
      if (matrix[0][0] == "X" && matrix[1][1] == "X" && matrix[2][2] == "X") {
        return [true, 1];
      } else if (matrix[0][0] == "O" &&
          matrix[1][1] == "O" &&
          matrix[2][2] == "O") {
        return [true, 2];
      } else if (matrix[0][2] == "X" &&
          matrix[1][1] == "X" &&
          matrix[2][0] == "X") {
        return [true, 1];
      } else if (matrix[0][2] == "O" &&
          matrix[1][1] == "O" &&
          matrix[2][0] == "O") {
        return [true, 2];
      }
    }

    //checking draw match
    if (move == 9) {
      return [true, 3];
    }
    return [false, 0];
  }

  @override
  Widget build(BuildContext context) {
    Widget boardPiece(int index) {
      String currentBox = boardMatrix[index ~/ 3][index % 3];
      return GridTile(
        child: FlatButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: widget.theme == "light" ? Colors.black54 : Colors.white54,
            ),
          ),
          color: currentBox != "" ? (widget.theme == "dark" ? Colors.white : Colors.black) : null,
          onPressed: () {
            if (currentBox == "" && isEngaged == false) {
              changeBoardValue(index);
              setState(() {
                move += 1;
              });
            }
          },
          child: currentBox == ""
              ? Text(
                  currentBox,
                )
              : Image.asset(
                  "assets/images/$currentBox ${widget.theme}.jpg",
                  fit: BoxFit.cover,
                ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'NO',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'YES',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: move % 2 != 0 ? Text("Player 1") : Text("Player 2"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, i) {
                return boardPiece(i);
              },
            ),
          ),
        ),
      ),
    );
  }
}
