import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  // Holds the cocktail data, which can now be null
  final Map<String, dynamic>? cocktail;

  // Constructor for DetailsPage, now accepts nullable cocktail data
  DetailsPage({this.cocktail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Function to build a text section if the key exists and is not empty
    Widget buildTextSection(String title, String? value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0), // Space between sections
        child: value != null && value.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 4), // Small gap between title and content
                  Text(value, style: Theme.of(context).textTheme.bodyText2),
                ],
              )
            : SizedBox.shrink(),
      );
    }

    // Generate ingredient list
    Widget buildIngredientList() {
      List<Widget> ingredientsWidgets = [];
      if (cocktail != null) {
        for (int i = 1; i <= 15; i++) {
          var ingredient = cocktail!['strIngredient$i'];
          var measure = cocktail!['strMeasure$i'];
          if (ingredient != null && ingredient.isNotEmpty) {
            ingredientsWidgets.add(
              Text('$ingredient: ${measure ?? 'Not specified'}'),
            );
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: ingredientsWidgets);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Set the background color of the AppBar to red
        title: Text(
          cocktail?['strDrink'] ?? 'Cocktail Details',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
      ),
      body: cocktail == null
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (cocktail!['strDrinkThumb'] != null)
                      Center(
                        child: Image.network(
                          cocktail!['strDrinkThumb'],
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image); // Placeholder image on error
                          },
                        ),
                      ),
                    SizedBox(height: 24), // Added space between image and ingredients

                    // Ingredient list
                    Text('Ingredients:', style: Theme.of(context).textTheme.headline6),
                    buildIngredientList(),

                    SizedBox(height: 24), // Space between sections

                    // Instructions section
                    buildTextSection('Instructions', cocktail!['strInstructions']),

                    // Category section
                    buildTextSection('Category', cocktail!['strCategory']),

                    // Alcoholic content section
                    buildTextSection('Alcoholic', cocktail!['strAlcoholic']),

                    // Glass type section
                    buildTextSection('Glass', cocktail!['strGlass']),
                  ],
                ),
              ),
            ),
    );
  }
}
