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
  int _currentIndex = 0; // Current index for the BottomNavigationBar
  Map<String, dynamic>? cocktail; // Declares a variable to hold the cocktail data
  bool showDetailsIndicator = false; // Declares a variable to control the visibility of the indicator

  // Function to fetch random cocktail data
  Future<void> fetchCocktail() async {
    try {
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
      final Map<String, dynamic> newCocktail = json.decode(response.body)['drinks'][0];
      setState(() {
        cocktail = newCocktail;
        showDetailsIndicator = true; // Enable the indicator when data is fetched
        // Do not change _currentIndex here, just update the indicator
        // Update the "Details" tab label with a badge
        navBarItems[1] = BottomNavigationBarItem(
          icon: Icon(Icons.details),
          label: 'Details${showDetailsIndicator ? '  ●' : ''}',
        );
      });
    } catch (e) {
      print('Failed to fetch cocktail: $e');
    }
  }

  // Function to handle navigation bar tap
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1 && cocktail != null) { // Make sure there is a cocktail data to show
        showDetailsIndicator = false; // Reset the indicator when navigating to details
        // Update the "Details" tab label without the badge
        navBarItems[1] = BottomNavigationBarItem(
          icon: Icon(Icons.details),
          label: 'Details',
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(cocktail: cocktail!)),
        );
      }
      if (_currentIndex == 0) {
        fetchCocktail();
      }
    });
  }

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.shuffle),
      label: 'Random',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.details),
      label: 'Details',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.help),
      label: 'Help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail Explorer'),
      ),
      body: _currentIndex == 2
          ? CocktailExplorer()
          : Center(child: Text('Tap on a navigation item')), // Placeholder for other indices
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: navBarItems,
        selectedItemColor: Colors.red, // Change selected item color to dark red
        unselectedItemColor: Colors.grey, // Unselected items are grey
        backgroundColor: Colors.white, // Background is white
        type: BottomNavigationBarType.fixed, // Fix the navigation bar items to equally spaced
      ),
    );
  }
}
