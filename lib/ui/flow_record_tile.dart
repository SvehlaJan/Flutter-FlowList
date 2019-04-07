import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';

class FlowRecordTile extends StatelessWidget {
//  final Animation<double> _animation;
  final FlowRecord _record;
  final VoidCallback _onTap;
  final UserRepository _userRepository = UserRepository.get();

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
        elevation: 4.0,
          color: Theme.of(context).cardColor,
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      width: Constants.avatarImageSize,
                      height: Constants.avatarImageSize,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: _userRepository.getPhotoUrl() ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_record.getUserDateString(),
                          style: Theme.of(context).textTheme.subtitle),
                      Container(height: 4.0),
                      Text(
                        "1. " + (_record.firstEntry ?? ""),
                        style: Theme.of(context).textTheme.caption,
                      ),
//                      Container(height: 2.0),
                      Text("2. " + (_record.secondEntry ?? ""),
                          style: Theme.of(context).textTheme.caption),
//                      Container(height: 2.0),
                      Text("3. " + (_record.thirdEntry ?? ""),
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ],
              ))),
    );
  }
}
