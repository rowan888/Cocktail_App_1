import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart';

// The main widget for the cocktail explorer
class CocktailExplorer extends StatefulWidget {
  @override
  _CocktailExplorerState createState() => _CocktailExplorerState();
}

class _CocktailExplorerState extends State<CocktailExplorer> {
  // List to store the ingredients entered by the user
  final List<String> _ingredients = [];
  // List to store the cocktails fetched from the API
  final List<Map<String, dynamic>> _cocktails = [];
  // Controller for the text field
  final TextEditingController _controller = TextEditingController();
  // Boolean to track if a fetch operation is ongoing
  bool _isLoading = false;

  // Function to fetch the details of a single cocktail
  Future<Map<String, dynamic>> fetchCocktailDetails(String id) async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['drinks'].first as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load cocktail details');
    }
  }

  // Function to fetch cocktails based on the ingredients entered by the user
  Future<void> fetchCocktails() async {
    if (_isLoading) return; // Prevent duplicate fetches

    if (!mounted) return; // Check if the State object is still in the tree
    setState(() {
      _isLoading = true;
    });

    _cocktails.clear();
    try {
      final ingredientQuery = _ingredients.join(',');
      final response = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredientQuery'),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final List<dynamic>? drinksList = responseBody['drinks'];

        if (drinksList == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No cocktails found for the provided ingredients.')),
          );
          return;
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
          SnackBar(content: Text('Failed to fetch cocktails: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Ensure to dispose the TextEditingController when the State is disposed
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The build method for the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail Explorer'),
      ),
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
                  icon: Icon(Icons.clear),
                ),
              ),
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
            children: _ingredients.map((ingredient) => Chip(
              label: Text(ingredient),
              onDeleted: () {
                setState(() {
                  _ingredients.remove(ingredient);
                });
              },
            )).toList(),
            spacing: 8.0,
          ),
          ElevatedButton(
            child: Text('Find Cocktails'),
            onPressed: _ingredients.isEmpty ? null : fetchCocktails
          ),
          // Show a loading indicator if a fetch operation is ongoing
          if (_isLoading)
            CircularProgressIndicator(),
          // Display the fetched cocktails in a list
          Expanded(
            child: ListView.builder(
              itemCount: _cocktails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cocktails[index]['strDrink']),
                  trailing: ElevatedButton(
                    child: Text('View Details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(cocktail: _cocktails[index]),
                        ),
                      );
                    },
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
