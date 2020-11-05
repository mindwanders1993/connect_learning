import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist.dart' show Wishlist;
import '../widgets/wishlist_item.dart';
import '../providers/my_courses.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/wishlist';

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<Wishlist>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wishlist'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  // Chip(
                  //   label: Text(
                  //     '\$${cart.totalAmount.toStringAsFixed(2)}',
                  //     style: TextStyle(
                  //       color:
                  //           Theme.of(context).primaryTextTheme.headline6.color,
                  //     ),
                  //   ),
                  //   backgroundColor: Theme.of(context).primaryColor,
                  // ),
                  MyCourseButton(wishlist: wishlist)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: wishlist.items.length,
              itemBuilder: (ctx, i) => WishlistItem(
                wishlist.items.values.toList()[i].id,
                wishlist.items.keys.toList()[i],
                // wishlist.items.values.toList()[i].price,
                wishlist.items.values.toList()[i].quantity,
                wishlist.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyCourseButton extends StatefulWidget {
  const MyCourseButton({
    Key key,
    @required this.wishlist,
  }) : super(key: key);

  final Wishlist wishlist;

  @override
  _MyCourseButtonState createState() => _MyCourseButtonState();
}

class _MyCourseButtonState extends State<MyCourseButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child:
          _isLoading ? CircularProgressIndicator() : Text('ADD TO MY COURSES'),
      // onPressed: (widget.wishlist.totalAmount <= 0 || _isLoading)
      onPressed: (_isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<MyCourses>(context, listen: false).addMyCourse(
                widget.wishlist.items.values.toList(),
                // widget.wishlist.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.wishlist.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
