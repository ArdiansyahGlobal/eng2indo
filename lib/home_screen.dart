import 'package:flutter/material.dart';
import 'translate_widget.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  Widget _buildCustomButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 8.0,
        shadowColor: Colors.black45,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Eng2Indo",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.translate,
                size: 100,
                color: Colors.white,
              ),
              Divider(
                height: 40,
                thickness: 2,
                color: Colors.white,
              ),
              _buildCustomButton(
                context: context,
                title: "IND-ENG Translator",
                onTap: () async {
                  // Navigasi ke halaman TranslateWidget dan menunggu hasil terjemahan
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TranslateWidget(type: 'IND-ENG')),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildCustomButton(
                context: context,
                title: "ENG-IND Translator",
                onTap: () async {
                  // Navigasi ke halaman TranslateWidget dan menunggu hasil terjemahan
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TranslateWidget(type: 'ENG-IND')),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildCustomButton(
                context: context,
                title: "Play Quiz",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//pembaruan design pada homescreen jadi lebih berwarna dan bagus
