import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_list/generated/l10n.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/settings/login_view_model.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/R.dart';
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

  @override
  String getPageTitle() => S.of(context).login_title;

  void _validateAndSubmit(LoginViewModel model) async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      model.signInWithEmail(_email, _password);
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
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: R.string(context).general_email,
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) => val.isEmpty ? R.string(context).login_error_email_empty : null,
                          onSaved: (val) => _email = val,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: R.string(context).general_password,
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (val) => val.isEmpty ? (R.string(context).login_error_password_empty) : null,
                          onSaved: (val) => _password = val,
                        ),
                      ),
                      Expanded(child: Container()),
                      RaisedButton(
                        child: Text(R.string(context).login_button_login.toUpperCase(), style: Theme.of(context).textTheme.button),
                        onPressed: () => _validateAndSubmit(model),
                      ),
                      RaisedButton(
                        color: Colors.redAccent,
                        child: Text(R.string(context).login_button_google_login.toUpperCase(), style: Theme.of(context).textTheme.button),
                        onPressed: () => model.signInWithGoogle(),
                      ),
                      FlatButton(
                        child: Text(R.string(context).login_button_skip.toUpperCase(), style: Theme.of(context).textTheme.button),
                        onPressed: () => model.signInAnonymously(),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
