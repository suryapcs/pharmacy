import 'package:flutter/material.dart';
import '../models/medicine.dart';

class CartProvider extends ChangeNotifier {
  List<Medicine> _items = [];

  List<Medicine> get items => _items;

  double get total =>
      _items.fold(0, (sum, item) => sum + item.price);

  void add(Medicine med) {
    _items.add(med);
    notifyListeners();
  }

  void remove(Medicine med) {
    _items.remove(med);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
