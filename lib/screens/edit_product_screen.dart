import 'package:flutter/material.dart';
import 'package:clothingapp/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:clothingapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
      id: 'nullString', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != 'newProduct') {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findViewById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl
          'imageUrl': ''
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }

    _form.currentState?.save();
    // ignore: unnecessary_null_comparison, unrelated_type_equality_checks
    if (_editedProduct.id != 'nullString') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        //Navigator.of(context).pop();
      } catch (error) {
        await showDialog(
            context: context,
            builder: (cont) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('something went wrong, please try again later'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(cont).pop();
                        },
                        child: const Text('Okay')),
                  ],
                ));
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }

        // }).then((_) {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // });
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
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
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
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        initialValue: _initValues['title'],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'inputs required';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: val!,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              isFavoratie: _editedProduct.isFavoratie,
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: _initValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'inputs required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter number greater that zero';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              isFavoratie: _editedProduct.isFavoratie,
                              price: double.parse(val!),
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        initialValue: _initValues['description'],
                        maxLines: 5,
                        //textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'inputs required';
                          }
                          if (value.length < 10) {
                            return 'Please enter 10 caracters or more';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: val as String,
                              price: _editedProduct.price,
                              isFavoratie: _editedProduct.isFavoratie,
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('No image')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'image url'),
                              //initialValue: _initValues['imageUrl'],
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _saveForm,
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'inputs required';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('htps')) {
                                  return 'Please provide a valid link';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.jpg')) {
                                  return 'Please provide a valid image';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    isFavoratie: _editedProduct.isFavoratie,
                                    imageUrl: val!);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
