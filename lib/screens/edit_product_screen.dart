// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products_provider.dart';

class EditProductScreeen extends StatefulWidget {
  static const routeName = 'EditProductsCreen';
  @override
  _EditProductScreeenState createState() => _EditProductScreeenState();
}

class _EditProductScreeenState extends State<EditProductScreeen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', description: '', imageUrl: '', price: 0, title: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus &&
        Uri.parse(_imageUrlController.text).isAbsolute &&
        _imageUrlController.text.isNotEmpty) {
      setState(() {});
    }
  }

  void _onSaved() {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }

    _form.currentState!.save();
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(_editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be Empty';
                    }
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.title,
                        price: _editedProduct.price,
                        title: value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a price';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    } else if (double.tryParse(value)! <= 0) {
                      return 'Enter a number greater than 0';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.title,
                        price: double.parse(value!),
                        title: _editedProduct.title);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Description';
                    } else if (value.length <= 10) {
                      return 'Enter minimum 10 Characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: value!,
                        imageUrl: _editedProduct.title,
                        price: _editedProduct.price,
                        title: _editedProduct.title);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: _imageUrlController.text.isEmpty
                          ? Alignment.center
                          : null,
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Image.network(
                        _imageUrlController.text.isEmpty
                            ? 'https://icon-library.com/images/add-icon-png/add-icon-png-10.jpg'
                            : _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        validator: (value) {
                          if (!Uri.parse(value!).isAbsolute) {
                            return 'Enter a valid Url';
                          } else if (value.isEmpty) {
                            return ' Enter a Url';
                          }
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              imageUrl: value!,
                              price: _editedProduct.price,
                              title: _editedProduct.title);
                        },
                        onFieldSubmitted: (_) {
                          _onSaved();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
