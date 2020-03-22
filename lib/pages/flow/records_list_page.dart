import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/flow/record_detail_page.dart';
import 'package:flutter_flow_list/pages/flow/records_list_view_model.dart';
import 'package:flutter_flow_list/pages/settings/login_page.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:provider_architecture/provider_architecture.dart';

class RecordsListPage extends StatefulWidget {
  @override
  _RecordsListPageState createState() => new _RecordsListPageState();
}

class _RecordsListPageState extends BasePageState<RecordsListPage> with TickerProviderStateMixin {
  @override
  String getPageTitle() => "Flow notes";

  void _openRecordDetailPage(String date) {
    Navigator.pushNamed(context, Constants.recordDetailRoute, arguments: {RecordDetailPage.ARG_DATE: date});
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RecordsListViewModel>.withConsumer(
      viewModel: RecordsListViewModel(),
      onModelReady: (model) => model.listenToRecords(),
      builder: (context, model, child) {
        if (model.busy || model.records == null) {
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
                      _openRecordDetailPage(record.apiDateStr);
                    }));
                  }),
              fab: FloatingActionButton(onPressed: () => _openRecordDetailPage(null), tooltip: 'Add', child: const Icon(Icons.add)));
        } else {
          return LoginPage();
        }
      },
    );
  }
}
