import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _authHint = '';

  @override
  String getPageTitle() => "Login";

  void _validateAndSubmit() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      Provider.of<UserRepository>(context).signInWithEmail(_email, _password);
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, Consumer<UserRepository>(
      builder: (BuildContext context, UserRepository userRepository, Widget child) {
        switch (userRepository.status) {
          case Status.Uninitialized:
          case Status.Unauthenticated:
            return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                        onSaved: (val) => _password = val,
                      ),
                      Container(
                          height: 80.0, padding: const EdgeInsets.all(16.0), child: Text(_authHint, style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center)),
                      RaisedButton(child: Text("Login", style: Theme.of(context).textTheme.button), onPressed: () => _validateAndSubmit()),
                      RaisedButton(
                          color: Colors.redAccent, child: Text('Google Login', style: Theme.of(context).textTheme.button), onPressed: () => userRepository.signInWithGoogle()),
                      RaisedButton(child: Text('Skip', style: Theme.of(context).textTheme.button), onPressed: () => userRepository.signInAnonymously()),
                    ],
                  ),
                ));
          case Status.Authenticated:
            return InkWell(
              child: Constants.centeredSuccessIndicator,
              onTap: () => Navigator.of(context).pop(true),
            );
          case Status.Authenticating:
            return Constants.centeredProgressIndicator;
        }
        return Constants.centeredProgressIndicator;
      },
    ));
  }
}
