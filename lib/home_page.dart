import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart';
import 'explorer_page.dart';
import 'help_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 3; // App starts on the help page.
  Map<String, dynamic>? cocktail; // Holds the data for the current cocktail.
  bool showDetailsIndicator = false; // Controls the visibility of the details indicator.

  // fetchCocktail fetches a random cocktail from an API.
  Future<void> fetchCocktail() async {
    try {
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
      final Map<String, dynamic> newCocktail = json.decode(response.body)['drinks'][0];
      setState(() {
        cocktail = newCocktail;
        showDetailsIndicator = true;
        navBarItems[1] = BottomNavigationBarItem(
          icon: Icon(Icons.details),
          label: 'Details${showDetailsIndicator ? ' ●' : ''}',
        );
      });
    } catch (e) {
      print('Failed to fetch cocktail: $e');
    }
  }

  // onTabTapped handles the action when a tab is tapped.
  void onTabTapped(int index) {
    if (index == 1 && cocktail != null) {
      setState(() {
        showDetailsIndicator = false;
        navBarItems[1] = BottomNavigationBarItem(
          icon: Icon(Icons.details),
          label: 'Details',
        );
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsPage(cocktail: cocktail!)),
      );
    } else {
      setState(() {
        _currentIndex = index;
        if (index == 0) {
          fetchCocktail();
        }
      });
    }
  }

  // navBarItems holds the items for the bottom navigation bar.
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
      icon: Icon(Icons.help_outline),
      label: 'Help',
    ),
  ];

  // build returns the widget for HomePage.
  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidgets = [
      Center(child: Text('View your cocktail by pressing the "Details" Button!')),
      if (cocktail != null) DetailsPage(cocktail: cocktail!) else Container(),
      CocktailExplorer(), 
      HelpPage(), 
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Cocktail Explorer'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pageWidgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: navBarItems,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}