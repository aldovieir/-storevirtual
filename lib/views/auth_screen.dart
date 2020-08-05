import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/widget/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 18, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 110),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 45,
                    ),
                    transform: Matrix4.rotationZ(-9 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(2, 20)),
                      ],
                    ),
                    child: Text(
                      'Minha Loja',
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 40,
                        fontFamily: 'Anton',
                      ),
                    ),
                  ),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
