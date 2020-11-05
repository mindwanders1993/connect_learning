import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/wishlist_screen.dart';
import './screens/courses_overview_screen.dart';
import './screens/course_detail_screen.dart';
import './providers/courses.dart';
import './providers/wishlist.dart';
import './providers/my_courses.dart';
import './providers/auth.dart';
import 'screens/my_courses_screen.dart';
import './screens/user_courses_screen.dart';
import './screens/edit_course_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Courses>(
          update: (ctx, auth, previousProducts) => Courses(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider<Wishlist>(create: (ctx) => Wishlist()),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          update: (ctx, auth, previousOrders) => MyCourses(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.myCourses,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Connect Learning',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? CoursesOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            CourseDetailScreen.routeName: (ctx) => CourseDetailScreen(),
            WishlistScreen.routeName: (ctx) => WishlistScreen(),
            MyCoursesScreen.routeName: (ctx) => MyCoursesScreen(),
            UserCoursesScreen.routeName: (ctx) => UserCoursesScreen(),
            EditCourseScreen.routeName: (ctx) => EditCourseScreen(),
          },
        ),
      ),
    );
  }
}
