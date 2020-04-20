import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../providers/meal.dart';
import '../providers/meals.dart';

class EditMealScreen extends StatefulWidget {
  static const routeName = '/edit-meal';

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  String _vegNonVeg;
  String _vegNonVegResult;
  String _category;
  String _categoryResult;
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedMeal = Meal(
    id: null,
    title: '',
    description: '',
    vegNonVeg: '',
    category: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'vegNonVeg': '',
    'category': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _vegNonVeg = '';
    _category = '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final mealId = ModalRoute.of(context).settings.arguments as String;
      if (mealId != null) {
        _editedMeal =
            Provider.of<Meals>(context, listen: false).findById(mealId);
        _initValues = {
          'title': _editedMeal.title,
          'description': _editedMeal.description,
          'vegNonVeg': _editedMeal.vegNonVeg,
          'category': _editedMeal.category,
          'price': _editedMeal.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedMeal.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
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
      _vegNonVegResult = _vegNonVeg;
      _categoryResult = _category;
      _isLoading = true;
    });

    // print(_editedMeal.category);
    // print(_editedMeal.vegNonVeg);


    if (_editedMeal.id != null) {
      await Provider.of<Meals>(context, listen: false)
          .updateMeal(_editedMeal.id, _editedMeal);
    } else {
      try {
        await Provider.of<Meals>(context, listen: false).addMeals(_editedMeal);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong...'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Meal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Title';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        _editedMeal = Meal(
                          id: _editedMeal.id,
                          isFavorite: _editedMeal.isFavorite,
                          category: _category,
                          vegNonVeg: _vegNonVeg,
                          title: value,
                          description: _editedMeal.description,
                          price: _editedMeal.price,
                          imageUrl: _editedMeal.imageUrl,
                        ),
                      },
                    ),
                    DropDownFormField(
                      titleText: 'Veg/Non-Veg',
                      hintText: 'Please choose one',
                      value: _vegNonVeg,
                      onSaved: (value1) {
                        setState(() {
                          _vegNonVeg = value1;
                        });
                      },
                      onChanged: (value1) {
                        setState(() {
                          _vegNonVeg = value1;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Veg",
                          "value": "Veg",
                        },
                        {
                          "display": "Non-Veg",
                          "value": "Non-Veg",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                    DropDownFormField(
                      titleText: 'Category',
                      hintText: 'Please choose one',
                      value: _category,
                      onSaved: (value2) {
                        setState(() {
                          _category = value2;
                        });
                      },
                      onChanged: (value2) {
                        setState(() {
                          _category = value2;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Starters",
                          "value": "Starters",
                        },
                        {
                          "display": "Main Course",
                          "value": "Main Course",
                        },
                        {
                          "display": "Dessert",
                          "value": "Dessert",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please Enter Amount greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        _editedMeal = Meal(
                          id: _editedMeal.id,
                          isFavorite: _editedMeal.isFavorite,
                          title: _editedMeal.title,
                          category: _category,
                          vegNonVeg: _vegNonVeg,
                          description: _editedMeal.description,
                          price: double.parse(value),
                          imageUrl: _editedMeal.imageUrl,
                        ),
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      // maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Description';
                        }
                        if (value.length < 10) {
                          return 'Description should be atleast 10 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        _editedMeal = Meal(
                          id: _editedMeal.id,
                          isFavorite: _editedMeal.isFavorite,
                          title: _editedMeal.title,
                          category: _category,
                          vegNonVeg: _vegNonVeg,
                          description: value,
                          price: _editedMeal.price,
                          imageUrl: _editedMeal.imageUrl,
                        ),
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
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (value) => _saveForm(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please Enter a valid URL';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please Enter a valid URL';
                              // }
                              return null;
                            },
                            onSaved: (value) => {
                              _editedMeal = Meal(
                                id: _editedMeal.id,
                                isFavorite: _editedMeal.isFavorite,
                                title: _editedMeal.title,
                                category: _category,
                                vegNonVeg: _vegNonVeg,
                                description: _editedMeal.description,
                                price: _editedMeal.price,
                                imageUrl: value,
                              ),
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
