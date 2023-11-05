import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help', style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.red, // Set background color to red
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Help Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. To explore random cocktails, tap the "Random" tab at the bottom of the screen.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '2. To view details of a cocktail, tap the "Details" tab after fetching a random cocktail.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '3. To explore cocktails by adding specific ingredients, tap the "Explore" tab.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
