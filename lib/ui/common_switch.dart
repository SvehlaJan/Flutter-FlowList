import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CommonSwitch extends StatelessWidget {
  final defValue;
  final ValueChanged<bool> onChanged;

  CommonSwitch({@required this.onChanged, this.defValue = false});

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? Switch(
            value: defValue,
            onChanged: onChanged,
          )
        : CupertinoSwitch(
            value: defValue,
            onChanged: onChanged,
          );
  }
}
