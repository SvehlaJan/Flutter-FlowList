import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MainState extends Equatable {
  MainState([List props = const []]) : super(props);
}

class Uninitialized extends MainState {
  @override
  String toString() => 'Uninitialized';
}

class Initialized extends MainState {
  @override
  String toString() => 'Initialized';
}