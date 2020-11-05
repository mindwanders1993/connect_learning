import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/my_courses_screen.dart';
import '../screens/user_courses_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Courses'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My Courses'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MyCoursesScreen.routeName);
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => MyCoursesScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Courses'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserCoursesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Navigator.of(context)
                  .pushReplacementNamed(UserCoursesScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
