import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_courses.dart' show MyCourses;
import '../widgets/my_course_item.dart';
import '../widgets/app_drawer.dart';

class MyCoursesScreen extends StatelessWidget {
  static const routeName = '/myCourses';

  @override
  Widget build(BuildContext context) {
    print('building myCourses');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your MyCourses'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<MyCourses>(context, listen: false)
            .fetchAndSetMyCourses(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<MyCourses>(
                builder: (ctx, myCourseData, child) => ListView.builder(
                  itemCount: myCourseData.myCourses.length,
                  itemBuilder: (ctx, i) =>
                      MyCourseItem(myCourseData.myCourses[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
