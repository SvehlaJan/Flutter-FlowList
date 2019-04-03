import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';

class FlowRecordTile extends StatelessWidget {
//  final Animation<double> _animation;
  final FlowRecord _record;
  final VoidCallback _onTap;

  FlowRecordTile(
      //      this._animation,
      this._record,
      this._onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Card(
          color: Colors.white,
          child: Center(
            child: new Container(
                padding: new EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          _record.getUserDateString(),
                          style: TextStyle(color: Colors.black, fontSize: 30.0),
                        ),
                      ],
                    ),
                    Text(
                      _record.firstEntry,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Text(
                      _record.secondEntry,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Text(
                      _record.thirdEntry,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ],
                )),
          )),
    );
  }
}
