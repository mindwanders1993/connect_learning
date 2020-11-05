import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import '../widgets/user_course_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_course_screen.dart';

class UserCoursesScreen extends StatelessWidget {
  static const routeName = '/user-courses';

  Future<void> _refreshCourses(BuildContext context) async {
    await Provider.of<Courses>(context, listen: false).fetchAndSetCourses(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Courses'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCourseScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCourses(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCourses(context),
                    child: Consumer<Courses>(
                      builder: (ctx, coursesData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: coursesData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserCourseItem(
                                coursesData.items[i].id,
                                coursesData.items[i].title,
                                coursesData.items[i].webUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
