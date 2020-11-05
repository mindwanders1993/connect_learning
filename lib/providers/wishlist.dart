import 'package:flutter/foundation.dart';

class WishlistItem {
  final String id;
  final String title;
  final int quantity;
  // final double price;

  WishlistItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    // @required this.price,
  });
}

class Wishlist with ChangeNotifier {
  Map<String, WishlistItem> _items = {};

  Map<String, WishlistItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  // double get totalAmount {
  //   var total = 0.0;
  //   _items.forEach((key, cartItem) {
  //     total += cartItem.price * cartItem.quantity;
  //   });
  //   return total;
  // }

  void addItem(
    String courseId,
    // double price,
    String title,
  ) {
    if (_items.containsKey(courseId)) {
      // change quantity...
      _items.update(
        courseId,
        (existingWishlistItem) => WishlistItem(
          id: existingWishlistItem.id,
          title: existingWishlistItem.title,
          // price: existingWishlistItem.price,
          quantity: existingWishlistItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        courseId,
        () => WishlistItem(
          id: DateTime.now().toString(),
          title: title,
          // price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String courseId) {
    _items.remove(courseId);
    notifyListeners();
  }

  void removeSingleItem(String courseId) {
    if (!_items.containsKey(courseId)) {
      return;
    }
    if (_items[courseId].quantity > 1) {
      _items.update(
          courseId,
          (existingWishlistItem) => WishlistItem(
                id: existingWishlistItem.id,
                title: existingWishlistItem.title,
                // price: existingWishlistItem.price,
                quantity: existingWishlistItem.quantity - 1,
              ));
    } else {
      _items.remove(courseId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
