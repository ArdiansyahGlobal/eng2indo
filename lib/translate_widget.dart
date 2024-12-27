import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Untuk debounce

class TranslateWidget extends StatefulWidget {
  final String type;

  TranslateWidget({required this.type});

  @override
  _TranslateWidgetState createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = '';
  bool _isLoading = false;
  Timer? _debounce; // Timer untuk debounce

  Future<void> _translateText(String text) async {
    if (text.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiUrl = widget.type == 'IND-ENG'
        ? 'http://192.168.1.15:8000/translate/ind-eng/' // Ganti dengan IP komputer
        : 'http://192.168.1.15:8000/translate/eng-ind/'; // Ganti dengan IP komputer

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _translatedText = data['translated'];
        });
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Membatalkan debounce jika halaman ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 'IND-ENG' ? "IND-ENG Translator" : "ENG-IND Translator",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.blueAccent,
              size: 30,
            ),
          ),
        ),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon Header
              Column(
                children: [
                  Icon(
                    Icons.translate,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.type == 'IND-ENG'
                        ? "Translate from Indonesian to English"
                        : "Translate from English to Indonesian",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Input Textbox
              Text(
                "Enter Text:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Type here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(Duration(milliseconds: 500), () {
                    _translateText(text);
                  });
                },
              ),
              SizedBox(height: 20),
              // Output Textbox
              Text(
                "Translation:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                  _translatedText.isEmpty
                      ? "Translation will appear here"
                      : _translatedText,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//sudah di update untuk design yang bagus dan ada perubahan pada translate otomatis tidak perlu menekan button translate lagi untuk mentraslate dan ada tombol back ke halaman homescreen karena sebelumnya belum ada