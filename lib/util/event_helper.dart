import 'dart:async';

extension StreamEvent on StreamController<Event> {
  void sendEvent() => add(Event());
}

class Event {}
