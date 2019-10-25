import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flow_list/bloc/main_event.dart';
import 'package:flutter_flow_list/bloc/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => Uninitialized();

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  Stream<MainState> _mapAppStartedToState() async* {
    yield Initialized();
  }
}
