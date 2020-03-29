import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/settings/login_view_model.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

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

  void _validateAndSubmit(LoginViewModel model) async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      model.signInWithEmail(_email, _password);
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
        viewModel: LoginViewModel(),
        onModelReady: (model) {},
        builder: (context, model, child) {
          if (model.busy == null) {
            return buildScaffold(context, Constants.centeredProgressIndicator);
          }
          return buildScaffold(context, _buildBody(context, model));
        });
  }

  Widget _buildBody(BuildContext context, LoginViewModel model) {
    switch (model.currentStatus) {
      case Status.Uninitialized:
      case Status.Unauthenticated:
        return _buildForm(context, model);
      case Status.Authenticated:
        return InkWell(
          child: Constants.centeredSuccessIndicator,
          onTap: () => Navigator.of(context).pop(true),
        );
      case Status.Authenticating:
        return Constants.centeredProgressIndicator;
    }
    return Constants.centeredProgressIndicator;
  }

  Widget _buildForm(BuildContext context, LoginViewModel model) {
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
              Container(height: 80.0, padding: const EdgeInsets.all(16.0), child: Text(_authHint, style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center)),
              RaisedButton(child: Text("Login", style: Theme.of(context).textTheme.button), onPressed: () => _validateAndSubmit(model)),
              RaisedButton(color: Colors.redAccent, child: Text('Google Login', style: Theme.of(context).textTheme.button), onPressed: () => model.signInWithGoogle()),
              RaisedButton(child: Text('Skip', style: Theme.of(context).textTheme.button), onPressed: () => model.signInAnonymously()),
            ],
          ),
        ));
  }
}
