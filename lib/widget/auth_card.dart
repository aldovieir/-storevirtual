import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exception/fire_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoanding = false;
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 1.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset(0, 1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ocorreu um erro'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoanding = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await auth.singup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on FireException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
    setState(() {
      _isLoanding = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else
      setState(() {
        _authMode = AuthMode.Login;
      });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final deviseSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.Login ? 310 : 370,
        width: deviseSize.width * 0.80,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um email valido';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Informe uma senha válida!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirme a Senha'),
                      obscureText: true,
                      // ignore: missing_return
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Senhas diferentes!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              Spacer(),
              if (_isLoanding)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 30,
                  ),
                  child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                  onPressed: _submit,
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                    _authMode == AuthMode.Login ? 'REGISTRE-SE' : 'ENTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
