import 'package:flutter/material.dart';
import 'package:app_medicamentos/pages/register/name_register.dart';
import 'package:app_medicamentos/constants.dart';

import '../models/user_model.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StartPage();
  }
}

class _StartPage extends State <StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(55, 0, 55, 100),
            child: Container(
              child: Image(
                image: AssetImage('assets/images/logo_apesaam.png'),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Container(
              width: AppStyles.anchoBoton,
              height: AppStyles.altoBoton,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil <dynamic>(
                      context,
                      MaterialPageRoute <dynamic>(
                          builder: (BuildContext context) => NameRegister(user: new User(),)
                      ),
                      (route) => false,
                  );
                },
                style: AppStyles.botonPrincipal,
                child: Text("Registrarse",
                  style: AppStyles.textoBoton,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}