import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  int _cartItemCount = 0;

  int get cartItemCount => _cartItemCount;

  void setCartItemCount(int count) {
    _cartItemCount = count;
    notifyListeners();
  }

  // void incrementCartItemCount() {
  //   _cartItemCount++;
  //   notifyListeners();
  // }

  // void decrementCartItemCount() {
  //   _cartItemCount--;
  //   notifyListeners();
  // }
}
