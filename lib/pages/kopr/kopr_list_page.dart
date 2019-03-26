import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/entities/flow_record_entity.dart';
import 'package:flutter_flow_list/pages/base/firebase_database_page.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_flow_list/util/uidata.dart';

class KoprListPage extends FirebasePoweredPage {
  @override
  _KoprFlowPageState createState() => new _KoprFlowPageState();
}

class _KoprFlowPageState extends FirebasePoweredPageState<KoprListPage>
    with TickerProviderStateMixin {
  DatabaseReference _recordsRef;
  StreamSubscription<Event> _messagesSubscription;

  static const int kStartValue = 2;
  bool _reverseOrder = false;

  @override
  void initState() {
    super.initState();
  }

  void initFirebaseReferences(String userId) {
    super.initFirebaseReferences(userId);

    // Demonstrates configuring the database directly
//    final FirebaseDatabase database = new FirebaseDatabase(app: widget.app);
    // Demonstrates configuring to the database using a file
    final FirebaseDatabase database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    _recordsRef = database
        .reference()
        .child('kopr')
        .child('flow_notes')
        .child(userId)
        .child('records');
    _messagesSubscription =
        _recordsRef.limitToLast(10).onChildAdded.listen((Event event) {
      showContent();
      print('Child added: ${event.snapshot.value}');
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
    _recordsRef.once().then((DataSnapshot snapShot) {
      if (snapShot.value == null) {
        showEmpty();
      } else {
        showContent();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_messagesSubscription != null) {
      _messagesSubscription.cancel();
    }
  }

  void _openRecordEditPage(String date) {
    Navigator.pushNamed(context, UIData.koprAddRoute);
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
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget getContentView() {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
            query: _recordsRef,
            reverse: _reverseOrder,
            sort: _reverseOrder
                ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                : null,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              FlowRecord record = FlowRecord(
                  snapshot.key,
                  snapshot.value[FlowRecord.KEY_ENTRY_1],
                  snapshot.value[FlowRecord.KEY_ENTRY_2],
                  snapshot.value[FlowRecord.KEY_ENTRY_3]);
              return FlowRecordTile(animation, record, (() {
                _openRecordEditPage(snapshot.key);
              }));
            },
          ),
        ),
      ],
    );
  }
}
