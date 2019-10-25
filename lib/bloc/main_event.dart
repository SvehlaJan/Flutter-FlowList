import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MainEvent extends Equatable {
  MainEvent([List props = const []]) : super(props);
}

class AppStarted extends MainEvent {
  @override
  String toString() => 'AppStarted';
}
