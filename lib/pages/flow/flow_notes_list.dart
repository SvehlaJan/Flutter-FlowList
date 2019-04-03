import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/firebase_database_page.dart';
import 'package:flutter_flow_list/pages/flow/flow_note_detail.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_flow_list/util/constants.dart';

class FlowNotesListPage extends FirebasePoweredPage {
  @override
  _FlowNotesListPageState createState() => new _FlowNotesListPageState();
}

class _FlowNotesListPageState extends FirebasePoweredPageState<FlowNotesListPage>
    with TickerProviderStateMixin {
  final ScrollController listScrollController = new ScrollController();
  static const int kStartValue = 2;
  String _userId;
  CollectionReference _firestoreRef;

  @override
  void initState() {
    super.initState();
  }

  void initFirebaseReferences(String userId) async {
    super.initFirebaseReferences(userId);
    _userId = userId;
    _firestoreRef = Firestore.instance
        .collection(Constants.FIRESTORE_USERS)
        .document(_userId)
        .collection(Constants.FIRESTORE_FLOW_NOTES);
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

  @override
  List<Widget> getPageActions() {
    return [IconButton(icon: Icon(Icons.cancel), onPressed: logout)];
  }

  @override
  FloatingActionButton getPageFab() {
    return FloatingActionButton(
      onPressed: _onFabClicked,
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget getContentView() {
    return Column(
      children: <Widget>[
        Flexible(
          child: StreamBuilder(
            stream: _firestoreRef.snapshots(),
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
                      buildItem(index, snapshot.data.documents[index]),
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

  Widget buildItem(int index, DocumentSnapshot document) {
    FlowRecord record = FlowRecord(document.documentID, document[FlowRecord.KEY_ENTRY_1],
        document[FlowRecord.KEY_ENTRY_2], document[FlowRecord.KEY_ENTRY_3]);
    return FlowRecordTile(record, (() {
      _openRecordEditPage(document.documentID);
    }));
  }
}
