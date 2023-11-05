import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  // Holds the cocktail data
  final Map<String, dynamic> cocktail;

  // Constructor for DetailsPage
  DetailsPage({required this.cocktail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Sets the title to the cocktail name
        title: Text(cocktail['strDrink']),
      ),
      body: Padding(
        // Adds padding around the child widget
        padding: EdgeInsets.all(16.0),
        child: Column(
          // Aligns the children to the start of the column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Displays the ingredients
            Text('Ingredients:', style: TextStyle(fontSize: 24)),
            // Loops through the possible ingredients
            for (var i = 1; i <= 15; i++)
              // If the ingredient exists, it is displayed
              if (cocktail['strIngredient$i'] != null && cocktail['strIngredient$i'].isNotEmpty)
                Text('${cocktail['strIngredient$i']} - ${cocktail['strMeasure$i']}'),
            // Adds vertical space
            SizedBox(height: 20),
            // Displays the instructions
            Text('Instructions:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strInstructions']),
            // Adds vertical space
            SizedBox(height: 20),
            // Displays the category
            Text('Category:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strCategory']),
            // Adds vertical space
            SizedBox(height: 20),
            // Displays whether the cocktail is alcoholic
            Text('Alcoholic:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strAlcoholic']),
            // Adds vertical space
            SizedBox(height: 20),
            // Displays the type of glass
            Text('Glass:', style: TextStyle(fontSize: 24)),
            Text(cocktail['strGlass']),
          ],
        ),
      ),
    );
  }
}