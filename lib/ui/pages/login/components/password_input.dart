import 'package:flutter/material.dart';
import 'package:fordevs/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginPresenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
        stream: loginPresenter.isFormValidStream,
        builder: (context, snapshot) {
          return FilledButton(
            onPressed: snapshot.data == true
                ? () async {
                    await loginPresenter.auth();
                  }
                : null,
            child: Text('Entrar'.toUpperCase()),
          );
        });
  }
}
