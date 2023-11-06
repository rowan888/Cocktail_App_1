import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart';

// Main widget for the cocktail explorer
class CocktailExplorer extends StatefulWidget {
  @override
  CocktailExplorerState createState() => CocktailExplorerState();
}

class CocktailExplorerState extends State<CocktailExplorer> {
  // List to store the ingredients input by the user
  final List<String> _ingredients = [];
  // List to store the cocktails fetched from the API
  final List<Map<String, dynamic>> _cocktails = [];
  // Controller for the text field
  final TextEditingController _controller = TextEditingController();
  // Boolean to track if the app is currently fetching data
  bool _isLoading = false;

  // Defining your theme color here
  final Color themeColor = Colors.red;

  // Function to fetch details of a specific cocktail
  Future<Map<String, dynamic>> fetchCocktailDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id'),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['drinks'].first as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load cocktail details');
    }
  }

  // Function to fetch cocktails based on the ingredients
  Future<void> fetchCocktails() async {
  if (_isLoading) return;

  setState(() {
    _isLoading = true;
  });

  _cocktails.clear();
  try {
    for (String ingredient in _ingredients) {
      final response = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredient'),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final List<dynamic>? drinksList = responseBody['drinks'];

        if (drinksList == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No cocktails found with "$ingredient".')),
          );
          continue;
        }

        for (var drink in drinksList) {
          try {
            var detailedCocktail = await fetchCocktailDetails(drink['idDrink']);
            if (!mounted) return;
            setState(() {
              _cocktails.add(detailedCocktail);
            });
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load details for cocktail: ${drink['strDrink']}')),
            );
          }
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch cocktails with the ingredient "$ingredient": ${response.statusCode}')),
        );
      }
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  // Dispose the text controller when the widget is removed
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build the UI of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter ingredient',
                suffixIcon: IconButton(
                  onPressed: _controller.clear,
                  icon: Icon(Icons.clear, color: themeColor),
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                ),
                labelStyle: TextStyle(color: themeColor),
              ),
              cursorColor: themeColor,
              onSubmitted: (String value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _ingredients.add(value);
                    _controller.clear();
                  });
                }
              },
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _ingredients.map((ingredient) => Chip(
              label: Text(ingredient),
              deleteIconColor: themeColor,
              onDeleted: () {
                setState(() {
                  _ingredients.remove(ingredient);
                });
              },
            )).toList(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
            ),
            onPressed: _ingredients.isEmpty ? null : fetchCocktails,
            child: Text('Find Cocktails'),
          ),
          if (_isLoading)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(themeColor),
            ),
                    Expanded(
            child: ListView.builder(
              itemCount: _cocktails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cocktails[index]['strDrink']),
                  subtitle: Text(_cocktails[index]['strCategory'] ?? 'Unknown category'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor, 
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(cocktail: _cocktails[index]),
                        ),
                      );
                    },
                    child: Text('View Details'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}