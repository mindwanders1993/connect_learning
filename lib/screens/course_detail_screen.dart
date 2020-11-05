import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';

class CourseDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/course-detail';

  @override
  Widget build(BuildContext context) {
    final courseId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedCourse.title),
              background: Hero(
                tag: loadedCourse.id,
                child: Image.network(
                  loadedCourse.webUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                // Text(
                //   '\$${loadedCourse.price}',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 20,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedCourse.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
