import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/util/constants.dart';

class FlowRecordTile extends StatelessWidget {
  final FlowRecord _record;
  final VoidCallback _onTap;

  const FlowRecordTile({
    @required FlowRecord record,
    @required VoidCallback onTap,
  })  : _record = record,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: _onTap,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_record.getUserDateString(), style: Theme.of(context).textTheme.subtitle),
                  Container(height: 4.0),
                  Text("1. " + (_record.firstEntry ?? ""), style: Theme.of(context).textTheme.caption),
                  Text("2. " + (_record.secondEntry ?? ""), style: Theme.of(context).textTheme.caption),
                  Text("3. " + (_record.thirdEntry ?? ""), style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
            if (_record.imageUrl != null)
              Hero(
                tag: _record.imageUrl,
                child: SizedBox(
                  width: Constants.avatarImageSize,
                  height: Constants.avatarImageSize,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Constants.centeredProgressIndicator,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: _record.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
