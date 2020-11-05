import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/my_courses.dart' as myc;

class MyCourseItem extends StatefulWidget {
  final myc.MyCourseItem mycourse;

  MyCourseItem(this.mycourse);

  @override
  _MyCourseItemState createState() => _MyCourseItemState();
}

class _MyCourseItemState extends State<MyCourseItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.mycourse.courses.length * 20.0 + 110, 200)
          : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              // title: Text('\$${widget.mycourse.amount}'),
              title: Text('title'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.mycourse.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.mycourse.courses.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.mycourse.courses
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Text(
                          //   '${prod.quantity}x \$${prod.price}',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     color: Colors.grey,
                          //   ),
                          // )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
