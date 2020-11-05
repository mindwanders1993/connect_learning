import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'wishlist.dart';

class MyCourseItem {
  final String id;
  // final double amount;
  final List<WishlistItem> courses;
  final DateTime dateTime;

  MyCourseItem({
    @required this.id,
    // @required this.amount,
    @required this.courses,
    @required this.dateTime,
  });
}

class MyCourses with ChangeNotifier {
  List<MyCourseItem> _myCourses = [];
  final String authToken;
  final String userId;

  MyCourses(this.authToken, this.userId, this._myCourses);

  List<MyCourseItem> get myCourses {
    return [..._myCourses];
  }

  Future<void> fetchAndSetMyCourses() async {
    final url =
        'https://connect-learning.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<MyCourseItem> loadedMyCourses = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((myCourseId, myCourseData) {
      loadedMyCourses.add(
        MyCourseItem(
          id: myCourseId,
          // amount: courseData['amount'],
          dateTime: DateTime.parse(myCourseData['dateTime']),
          courses: (myCourseData['courses'] as List<dynamic>)
              .map(
                (item) => WishlistItem(
                  id: item['id'],
                  // price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _myCourses = loadedMyCourses.reversed.toList();
    notifyListeners();
  }

  Future<void> addMyCourse(
      // List<WishlistItem> wishlistCourses, double total) async {
      List<WishlistItem> wishlistCourses) async {
    final url =
        'https://connect-learning.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        // 'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'courses': wishlistCourses
            .map((wc) => {
                  'id': wc.id,
                  'title': wc.title,
                  'quantity': wc.quantity,
                  // 'price': wc.price,
                })
            .toList(),
      }),
    );
    _myCourses.insert(
      0,
      MyCourseItem(
        id: json.decode(response.body)['name'],
        // amount: total,
        dateTime: timestamp,
        courses: wishlistCourses,
      ),
    );
    notifyListeners();
  }
}
