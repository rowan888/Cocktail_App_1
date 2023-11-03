import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Cocktail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? cocktail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Cocktail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Generate'),
              onPressed: () async {
                final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
                final Map<String, dynamic> newCocktail = json.decode(response.body)['drinks'][0];
                setState(() {
                  cocktail = newCocktail;
                });
              },
            ),
            if (cocktail != null)
              ElevatedButton(
                child: Text('View Cocktail'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage(cocktail: cocktail!)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> cocktail;

  DetailsPage({required this.cocktail, Key? key}) : super(key: key);

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