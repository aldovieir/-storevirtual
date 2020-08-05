import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoanding = false;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jped');
    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
  }

  void _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoanding = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updadeProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro"'),
          content: Text('Ocorreu um erro ao salvar o produto!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoanding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
        title: Text('Formulário Produto'),
      ),
      body: _isLoanding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _formData['title'],
                        decoration: InputDecoration(labelText: 'Titulo'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => _formData['title'] = value,
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;

                          bool isValid = value.trim().length < 3;
                          if (isEmpty || isValid) {
                            return 'Digite um título válido!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'].toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          var newPrice = double.parse(value);
                          bool isValid = newPrice == null || newPrice <= 0;
                          if (isEmpty || isValid) {
                            return 'Digite um valor!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description'],
                        decoration: InputDecoration(labelText: 'Descrição'),
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                        onSaved: (value) => _formData['description'] = value,
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;

                          bool isValid = value.trim().length < 10;
                          if (isEmpty || isValid) {
                            return 'Digite uma descrição válida, com minimo 10 caracteres!';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'URL Imagem'),
                              focusNode: _imageFocusNode,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) => _formData['imageUrl'] = value,
                              validator: (value) {
                                bool isEmpty = value.trim().isEmpty;
                                bool isInvalid = !isValidImageUrl(value);
                                if (isEmpty || isInvalid) {
                                  return 'Informe URL válida!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informa a URL')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
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
