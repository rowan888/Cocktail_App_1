import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic>? cocktail;

  DetailsPage({this.cocktail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildTextSection(String title, String? value) {
      if (value == null || value.isEmpty) return SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    Widget buildIngredientList() {
      List<Widget> ingredientsWidgets = [];
      if (cocktail != null) {
        for (int i = 1; i <= 15; i++) {
          var ingredient = cocktail!['strIngredient$i'];
          var measure = cocktail!['strMeasure$i'];
          if (ingredient != null && ingredient.isNotEmpty) {
            ingredientsWidgets.add(
              Text(
                '• $ingredient${measure != null ? ' - $measure' : ''}',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: ingredientsWidgets);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          cocktail?['strDrink'] ?? 'Cocktail Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cocktail == null
            ? Center(child: Text('No data available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (cocktail!['strDrinkThumb'] != null)
                      Image.network(
                        cocktail!['strDrinkThumb'],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 24),
                    Text(
                      'Ingredients:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    buildIngredientList(),
                    SizedBox(height: 24),
                    buildTextSection('Instructions', cocktail!['strInstructions']),
                    buildTextSection('Category', cocktail!['strCategory']),
                    buildTextSection('Alcoholic', cocktail!['strAlcoholic']),
                    buildTextSection('Glass', cocktail!['strGlass']),
                  ],
                ),
              ),
      ),
    );
  }
}
