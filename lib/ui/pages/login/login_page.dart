// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../pages.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter loginPresenter;
  const LoginPage({
    Key? key,
    required this.loginPresenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(
              text: 'Login',
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                        stream: loginPresenter.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: loginPresenter.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                      child: StreamBuilder<String?>(
                          stream: loginPresenter.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(
                                  Icons.password,
                                  color: Theme.of(context).primaryColor,
                                ),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: loginPresenter.validatePassword,
                            );
                          }),
                    ),
                    StreamBuilder<bool>(
                        stream: loginPresenter.isFormValidStream,
                        builder: (context, snapshot) {
                          return FilledButton(
                            onPressed: snapshot.data == true ? () {} : null,
                            child: Text('Entrar'.toUpperCase()),
                          );
                        }),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Criar conta'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
