import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart'; // Imports the details page
import 'explorer_page.dart'; // Imports the CocktailExplorer page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? cocktail; // Declares a variable to hold the cocktail data
  bool showDetailsButton = false; // Declares a variable to control the visibility of the details button

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
                await fetchCocktail(); // Fetches a random cocktail
                if (cocktail != null) {
                  // If the cocktail data is not null, show the details button
                  setState(() {
                    showDetailsButton = true;
                  });
                }
              },
            ),
            if (showDetailsButton) // If showDetailsButton is true, show the details button
              ElevatedButton(
                child: Text('View Details'),
                onPressed: () {
                  // Navigate to the details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage(cocktail: cocktail!)),
                  );
                },
              ),
            ElevatedButton(
              child: Text('Cocktail Explorer'),
              onPressed: () {
                // Navigate to the CocktailExplorer page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CocktailExplorer()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCocktail() async {
    try {
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
      final Map<String, dynamic> newCocktail = json.decode(response.body)['drinks'][0];
      setState(() {
        cocktail = newCocktail;
      });
    } catch (e) {
      print('Failed to fetch cocktail: $e');
    }
  }
}