import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course.dart';
import '../providers/courses.dart';

class EditCourseScreen extends StatefulWidget {
  static const routeName = '/edit-course';

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  // final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _webUrlController = TextEditingController();
  final _webUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCourse = Course(
    id: null,
    title: '',
    // price: 0,
    description: '',
    webUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    // 'price': '',
    'webUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _webUrlFocusNode.addListener(_updateWebUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final courseId = ModalRoute.of(context).settings.arguments as String;
      if (courseId != null) {
        _editedCourse =
            Provider.of<Courses>(context, listen: false).findById(courseId);
        _initValues = {
          'title': _editedCourse.title,
          'description': _editedCourse.description,
          // 'price': _editedCourse.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'webUrl': _editedCourse.webUrl,
        };
        _webUrlController.text = _editedCourse.webUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _webUrlFocusNode.removeListener(_updateWebUrl);
    // _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _webUrlController.dispose();
    _webUrlFocusNode.dispose();
    super.dispose();
  }

  // void _updateImageUrl() {
  //   if (!_webUrlFocusNode.hasFocus) {
  //     // if ((!_webUrlController.text.startsWith('http') &&
  //     //         !_webUrlController.text.startsWith('https://forms')) ||
  //     //     (!_webUrlController.text.endsWith('.png') &&
  //     //         !_webUrlController.text.endsWith('.jpg') &&
  //     //         !_webUrlController.text.endsWith('.jpeg'))) {
  //     //   return;
  //     // }

  //     if (!_webUrlController.text.startsWith('https://forms')) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  void _updateWebUrl() {
    if (!_webUrlFocusNode.hasFocus) {
      if (!_webUrlController.text.startsWith('https://')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCourse.id != null) {
      await Provider.of<Courses>(context, listen: false)
          .updateCourse(_editedCourse.id, _editedCourse);
    } else {
      try {
        await Provider.of<Courses>(context, listen: false)
            .addCourse(_editedCourse);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCourse = Course(
                            title: value,
                            // price: _editedProduct.price,
                            description: _editedCourse.description,
                            webUrl: _editedCourse.webUrl,
                            id: _editedCourse.id,
                            isFavorite: _editedCourse.isFavorite);
                      },
                    ),
                    // TextFormField(
                    //   initialValue: _initValues['price'],
                    //   decoration: InputDecoration(labelText: 'Price'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   focusNode: _priceFocusNode,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context)
                    //         .requestFocus(_descriptionFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter a price.';
                    //     }
                    //     if (double.tryParse(value) == null) {
                    //       return 'Please enter a valid number.';
                    //     }
                    //     if (double.parse(value) <= 0) {
                    //       return 'Please enter a number greater than zero.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Product(
                    //         title: _editedProduct.title,
                    //         price: double.parse(value),
                    //         description: _editedProduct.description,
                    //         imageUrl: _editedProduct.imageUrl,
                    //         id: _editedProduct.id,
                    //         isFavorite: _editedProduct.isFavorite);
                    //   },
                    // ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCourse = Course(
                          title: _editedCourse.title,
                          // price: _editedCourse.price,
                          description: value,
                          webUrl: _editedCourse.webUrl,
                          id: _editedCourse.id,
                          isFavorite: _editedCourse.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _webUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _webUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Course URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _webUrlController,
                            focusNode: _webUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an course URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedCourse = Course(
                                title: _editedCourse.title,
                                // price: _editedCourse.price,
                                description: _editedCourse.description,
                                webUrl: value,
                                id: _editedCourse.id,
                                isFavorite: _editedCourse.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
