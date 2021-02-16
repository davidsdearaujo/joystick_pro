import 'package:joystick_pro/src/joystick_state.dart';
import 'package:rx_notifier/rx_notifier.dart';

class JoystickStore {
  final _loadingRx = RxNotifier(false);
  bool get isLoading => _loadingRx.value;
  void setLoading(bool value) => _loadingRx.value = value;

  final _stateRx = RxNotifier(JoystickState.empty());
  JoystickState get state => _stateRx.value;
  void update(JoystickState value) => _stateRx.value = value;

  final _errorRx = RxNotifier<Object>(null);
  Object get error => _errorRx.value;
  void setError(Object value) => _errorRx.value = value;

  void observe({void Function(bool) onLoading, void Function(JoystickState) onState, void Function(Object) onError}) {
    _stateRx.addListener(() => onState?.call(_stateRx.value));
    _errorRx.addListener(() => onError?.call(_errorRx.value));
    _loadingRx.addListener(() => onLoading?.call(_loadingRx.value));
  }

  void calculatePosition(double x, double y, double radius) {
    final isExternalOfCircunference = x * x + y * y > radius * radius;
    while (isExternalOfCircunference) {
      if (x > 0) x--;
      if (x < 0) x++;
      if (y > 0) y--;
      if (y < 0) y++;
    }
    update(state.copyWith(x: x, y: y));
  }

  void dispose() {
    _loadingRx.dispose();
    _stateRx.dispose();
    _errorRx.dispose();
  }
}
