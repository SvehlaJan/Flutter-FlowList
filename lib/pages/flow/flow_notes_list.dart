import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/pages/flow/flow_note_detail.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_flow_list/util/constants.dart';

class FlowNotesListPage extends StatefulPage {
  @override
  _FlowNotesListPageState createState() => new _FlowNotesListPageState();
}

class _FlowNotesListPageState
    extends StatefulPageState<FlowNotesListPage>
    with TickerProviderStateMixin {
  final ScrollController listScrollController = new ScrollController();
  FlowRepository _flowRepository = FlowRepository.get();
  UserRepository _userRepository = UserRepository.get();

  @override
  void initState() {
    super.initState();

    showContent();
  }

  void _openRecordEditPage(String date) {
    Navigator.pushNamed(
      context,
      Constants.koprAddRoute,
      arguments: {
        FlowNoteDetailPage.ARG_DATE: date,
      },
    );
  }

  Future<Null> _onFabClicked() async {
    _openRecordEditPage(null);
  }

  @override
  String getPageTitle() {
    return "Flow notes";
  }

//  @override
//  List<Widget> getPageActions() {
//    return [IconButton(icon: Icon(Icons.cancel), onPressed: logout)];
//  }

  @override
  FloatingActionButton getPageFab() {
    return _userRepository.isSignedIn()
        ? FloatingActionButton(
            onPressed: _onFabClicked,
            tooltip: 'Add',
            child: const Icon(Icons.add),
          )
        : null;
  }

  @override
  Widget getContentView() {
    if (!_userRepository.isSignedIn()) {
      return _buildSignInBlocker();
    }

    return Column(
      children: <Widget>[
        Flexible(
          child: StreamBuilder(
            stream: _flowRepository.getFlowRecords(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor)));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      _buildItem(index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  reverse: false,
                  controller: listScrollController,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignInBlocker() {
    return Center(
        child: RaisedButton(
            onPressed: _onGoogleSignIn,
            color: Colors.redAccent,
            child: new Text('Google Login',
                style: Theme.of(context).textTheme.title)));
  }

  Future<void> _onGoogleSignIn() async {
    showProgress();
    await _userRepository.signIn();
    showContent();
  }

  Widget _buildItem(int index, DocumentSnapshot document) {
    FlowRecord record = FlowRecord.withDateStr(
        document.documentID,
        document[FlowRecord.KEY_ENTRY_1],
        document[FlowRecord.KEY_ENTRY_2],
        document[FlowRecord.KEY_ENTRY_3]);
    return FlowRecordTile(record, (() {
      _openRecordEditPage(document.documentID);
    }));
  }
}
