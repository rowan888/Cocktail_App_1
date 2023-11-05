import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart';

class CocktailExplorer extends StatefulWidget {
  CocktailExplorer({Key? key}) : super(key: key);

  @override
  _CocktailExplorerState createState() => _CocktailExplorerState();
}

class _CocktailExplorerState extends State<CocktailExplorer> {
  final List<String> _ingredients = [];
  final List<Map<String, dynamic>> _cocktails = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> fetchCocktails() async {
    setState(() => _isLoading = true);
    try {
      _cocktails.clear();
      // Assuming you want to find cocktails that can be made with all ingredients
      String ingredients = _ingredients.join(',');
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredients'));

      if (response.statusCode == 200) {
        final List<dynamic> newCocktails = json.decode(response.body)['drinks'] ?? [];
        _cocktails.addAll(newCocktails.cast<Map<String, dynamic>>());
      } else {
        // Handle non-200 responses
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch cocktails')));
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
              onSubmitted: (value) => addIngredient(value),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _ingredients.map((ingredient) => Chip(
              label: Text(ingredient),
              onDeleted: () => removeIngredient(ingredient),
            )).toList(),
          ),
          ElevatedButton(
            child: Text('Find Cocktails'),
            onPressed: _ingredients.isNotEmpty ? fetchCocktails : null,
          ),
          if (_isLoading)
            CircularProgressIndicator(),
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
                        MaterialPageRoute(builder: (context) => DetailsPage(cocktail: _cocktails[index])),
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

  void addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
        _controller.clear();
      });
    }
  }

  void removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }
}
