import 'package:flutter/material.dart';
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

// Define a stateless widget for the details page
class DetailsPage extends StatelessWidget {
  // Declare a final map to hold the cocktail data
  final Map<String, dynamic> cocktail;

  // Define a constructor for the DetailsPage widget
  DetailsPage({required this.cocktail, Key? key}) : super(key: key);

  // Override the build method to describe the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget which provides a framework which implements the basic material design visual layout structure
    return Scaffold(
      // Set the app bar of the Scaffold
      appBar: AppBar(
        // Set the title of the app bar to the name of the cocktail
        title: Text(cocktail['strDrink']),
      ),
      // Set the body of the Scaffold
      body: Padding(
        // Add padding around the body
        padding: EdgeInsets.all(16.0),
        // Use a Column widget to arrange its children vertically
        child: Column(
          // Align the children to the start of the column
          crossAxisAlignment: CrossAxisAlignment.start,
          // Define the children of the column
          children: <Widget>[
            // Displays the ingredients of the cocktail
            Text('Ingredients:', style: TextStyle(fontSize: 24)),
            for (var i = 1; i <= 15; i++)
              if (cocktail['strIngredient$i'] != null && cocktail['strIngredient$i'].isNotEmpty)
                Text('${cocktail['strIngredient$i']} - ${cocktail['strMeasure$i']}'),
            SizedBox(height: 20),
            // Displays the instructions of the cocktail
            Text('Instructions:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strInstructions']),
            SizedBox(height: 20),
            // Displays the category of the cocktail
            Text('Category:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strCategory']),
            SizedBox(height: 20),
            // Displays whether the cocktail is alcoholic
            Text('Alcoholic:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strAlcoholic']),
            SizedBox(height: 20),
            // Displays the type of glass the cocktail is served in
            Text('Glass:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strGlass']),
          ],
        ),
      ),
    );
  }
}