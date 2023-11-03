import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail App'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Generate Random Cocktail'),
          onPressed: () async {
            final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
            final Map<String, dynamic> cocktail = jsonDecode(response.body)['drinks'][0];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPage(cocktail: cocktail)),
            );
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> cocktail;

  DetailPage({Key? key, required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Instructions:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strInstructions']),
          ],
        ),
      ),
    );
  }
}