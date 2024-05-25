import 'package:flutter/material.dart';

import '../models/filter.dart';

class HeaderSearch extends StatefulWidget {
  final Function(FilterType) onFilterChanged; // Callback-Funktion hinzufügen

  const HeaderSearch({Key? key, required this.onFilterChanged}) : super(key: key);

  @override
  _HeaderSearchState createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  int? _selectedButtonIndex = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });

    FilterType filterType = index == 0 ? FilterType.movies : FilterType.series;
    widget.onFilterChanged(filterType);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _onButtonPressed(0);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              backgroundColor: _selectedButtonIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.transparent,
              foregroundColor: _selectedButtonIndex == 0 ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Filme'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _onButtonPressed(1);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(40),
              backgroundColor: _selectedButtonIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.transparent,
              foregroundColor: _selectedButtonIndex == 1 ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Serien'),
          ),
        ),
      ],
    );
  }
}
