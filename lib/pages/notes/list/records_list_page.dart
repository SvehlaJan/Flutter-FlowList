import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/notes/list/records_list_view_model.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_flow_list/util/R.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';

class RecordsListPage extends StatefulWidget {
  @override
  _RecordsListPageState createState() => _RecordsListPageState();
}

class _RecordsListPageState extends BasePageState<RecordsListPage> with TickerProviderStateMixin {
  @override
  String getPageTitle() => R.string(context).records_list_title;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RecordsListViewModel>.withConsumer(
      viewModel: RecordsListViewModel(),
      onModelReady: (model) => model.listenToRecords(),
      builder: (context, model, child) {
        if (model.busy) {
          return buildScaffold(context, Constants.centeredProgressIndicator);
        }
        if (model.isUserLoggedIn) {
          return buildScaffold(
              context,
              ListView.builder(
                  itemCount: model.records.length,
                  itemBuilder: (context, index) {
                    FlowRecord record = model.records[index];
                    return FlowRecordTile(record, (() {
                      model.onRecordClicked(record);
                    }));
                  }),
              fab: FloatingActionButton(onPressed: () => model.onRecordClicked(null), tooltip: R.string(context).general_add, child: const Icon(Icons.add)));
        } else {
          return SafeArea(child: _buildEmptyPlaceholder(context, model));
        }
      },
    );
  }

  Widget _buildEmptyPlaceholder(BuildContext context, RecordsListViewModel model) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).accentColor));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: SvgPicture.asset("assets/images/welcome.svg", semanticsLabel: 'Acme Logo')),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(R.string(context).records_list_empty_title, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(R.string(context).records_list_empty_body, style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center),
              ),
              RaisedButton(child: Text(R.string(context).records_list_button_chat.toUpperCase()), onPressed: () => model.onChatClicked()),
              FlatButton(child: Text(R.string(context).records_list_button_login), onPressed: () => model.onLoginClicked()),
            ],
          ),
        ),
      ],
    );
  }
}
