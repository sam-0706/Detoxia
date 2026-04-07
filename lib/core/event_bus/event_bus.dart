import 'dart:async';

import 'package:detoxia/core/event_bus/events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventBus {
  final _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  Stream<T> on<T extends AppEvent>() =>
      _controller.stream.where((e) => e is T).cast<T>();

  void fire(AppEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

final eventBusProvider = Provider<EventBus>((ref) {
  final bus = EventBus();
  ref.onDispose(bus.dispose);
  return bus;
});
