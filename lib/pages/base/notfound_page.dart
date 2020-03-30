import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/R.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(R.string(context).error_page_not_found, style: Theme.of(context).textTheme.headline2),
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(false))
        ],
      ),
    );
  }
}
