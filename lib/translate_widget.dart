import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _translateText() async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter text to translate.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiUrl = widget.type == 'IND-ENG'
        ? 'http://192.168.1.15:8000/translate/ind-eng/'  // Ganti dengan IP komputer
        : 'http://192.168.1.15:8000/translate/eng-ind/';  // Ganti dengan IP komputer

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': _inputController.text}),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'IND-ENG' ? "IND-ENG Translator" : "ENG-IND Translator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Textbox
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
                hintText: "Type text here...",
              ),
              maxLines: 5,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            // Output Textbox
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
              ),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                _translatedText.isEmpty ? "Translation will appear here" : _translatedText,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // Translate Button
            ElevatedButton(
              onPressed: _isLoading ? null : _translateText,
              child: Text("Translate"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
