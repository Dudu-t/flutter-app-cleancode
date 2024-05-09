import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String?>(
        stream: loginPresenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(
                Icons.password,
                color: Theme.of(context).primaryColor,
              ),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            obscureText: true,
            onChanged: loginPresenter.validatePassword,
          );
        });
  }
}
