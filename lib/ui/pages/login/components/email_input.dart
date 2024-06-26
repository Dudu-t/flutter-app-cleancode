import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
        stream: loginPresenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: loginPresenter.validateEmail,
          );
        });
  }
}
