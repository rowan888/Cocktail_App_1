import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Welcome to the Help Section',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Find your way around the app with the following instructions:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          _buildHelpItem(
            context,
            icon: Icons.shuffle,
            title: 'Random Cocktail',
            description:
                'Explore random cocktails by tapping the "Random" tab at the bottom of the screen.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.details,
            title: 'Cocktail Details',
            description:
                'View details of a cocktail by selecting a drink from the "Random" or "Explore" sections.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.explore,
            title: 'Explore Ingredients',
            description:
                'Discover cocktails by selecting specific ingredients under the "Explore" tab.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 30, color:Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
