import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './course.dart';

class Courses with ChangeNotifier {
  List<Course> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Courses(this.authToken, this.userId, this._items);

  List<Course> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Course> get favoriteItems {
    return _items.where((courseItem) => courseItem.isFavorite).toList();
  }

  Course findById(String id) {
    return _items.firstWhere((course) => course.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetCourses([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://connect-learning.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://connect-learning.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Course> loadedCourses = [];
      extractedData.forEach((courseId, courseData) {
        loadedCourses.add(Course(
          id: courseId,
          title: courseData['title'],
          description: courseData['description'],
          isFavorite:
              favoriteData == null ? false : favoriteData[courseId] ?? false,
          webUrl: courseData['webUrl'],
        ));
      });
      _items = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCourse(Course course) async {
    final url =
        'https://connect-learning.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': course.title,
          'description': course.description,
          'webUrl': course.webUrl,
          'creatorId': userId,
        }),
      );
      final newCourse = Course(
        title: course.title,
        description: course.description,
        webUrl: course.webUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCourse);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCourse(String id, Course newCourse) async {
    final courseIndex = _items.indexWhere((course) => course.id == id);
    if (courseIndex >= 0) {
      final url =
          'https://connect-learning.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newCourse.title,
            'description': newCourse.description,
            'webUrl': newCourse.webUrl,
          }));
      _items[courseIndex] = newCourse;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCourse(String id) async {
    final url =
        'https://connect-learning.firebaseio.com/products/$id.json?auth=$authToken';
    final existingCourseIndex = _items.indexWhere((course) => course.id == id);
    var existingCourse = _items[existingCourseIndex];
    _items.removeAt(existingCourseIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Could not delete course.');
    }
    existingCourse = null;
  }
}
