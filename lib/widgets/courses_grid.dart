import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import 'course_item.dart';

class CoursesGrid extends StatelessWidget {
  final bool showFavs;

  CoursesGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courses = showFavs ? coursesData.favoriteItems : coursesData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: courses.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: courses[i],
        child: CourseItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
