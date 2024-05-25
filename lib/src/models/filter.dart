import 'package:flutter/foundation.dart';

class FilterModel extends ChangeNotifier {
  FilterType _selectedFilter = FilterType.movies; // Standardmäßig "Filme"

  FilterType get selectedFilter => _selectedFilter;

  void setSelectedFilter(FilterType filter) {
    _selectedFilter = filter;
    notifyListeners(); // Benachrichtigt Widgets, die diesen Wert verwenden
  }
}

enum FilterType { movies, series }