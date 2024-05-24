import 'package:flasher_ui/src/screens/movie_view.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int _selectedFilter = 0;

  void _onFilterTapped(int index) {
    setState(() {
      _selectedFilter = index;
    });
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile');
  }





  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _onFilterTapped(0);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              // Manually set the background color based on the selected state
              backgroundColor: _selectedFilter == 0 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: _selectedFilter == 0 ? Colors.white : Theme.of(context).colorScheme.primary, // Textfarbe des Buttons
            ),
            child: Text('Filme'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _onFilterTapped(1);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(40),
              // Manually set the background color based on the selected state
              backgroundColor: _selectedFilter == 1 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: _selectedFilter == 1 ? Colors.white : Theme.of(context).colorScheme.primary, // Textfarbe des Buttons
            ),
            child: const Text('Serien'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            _navigateToProfile(context);
          },
          iconSize: 50,
        ),
      ],
    );
  }
}
