import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  // Holds the cocktail data
  final Map<String, dynamic> cocktail;

  // Constructor for DetailsPage
  DetailsPage({required this.cocktail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detailed debugging: print each key and value
    cocktail.forEach((key, value) {
      print('$key: $value');
    });

    // Function to build a text widget if the key exists and is not empty
    Widget buildTextSection(String title, String? value) {
      if (value != null && value.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 24)),
            Text(value),
            SizedBox(height: 20),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink'] ?? 'Cocktail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cocktail['strDrinkThumb'] != null)
              Center(
                child: Image.network(
                  cocktail['strDrinkThumb'],
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading errors
                    return const Icon(Icons.broken_image); // or some placeholder image
                  },
                ),
              ),
            const SizedBox(height: 20),
            // Generate ingredient list
            const Text('Ingredients:', style: TextStyle(fontSize: 24)),
            ...List.generate(15, (i) => i + 1).map(
              (i) {
                var ingredient = cocktail['strIngredient$i'];
                var measure = cocktail['strMeasure$i'];
                if (ingredient != null && ingredient.isNotEmpty) {
                  return Text('$ingredient: ${measure ?? 'Not specified'}');
                }
                return const SizedBox.shrink();
              },
            ),
            // Instructions section
            buildTextSection('Instructions', cocktail['strInstructions']),
            // Category section
            buildTextSection('Category', cocktail['strCategory']),
            // Alcoholic content section
            buildTextSection('Alcoholic', cocktail['strAlcoholic']),
            // Glass type section
            buildTextSection('Glass', cocktail['strGlass']),
          ],
        ),
      ),
    );
  }
}
