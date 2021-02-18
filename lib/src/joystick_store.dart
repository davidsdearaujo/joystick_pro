import 'package:joystick_pro/src/joystick_state.dart';
import 'package:rx_notifier/rx_notifier.dart';

class JoystickStore {
  JoystickStore(double size) {
    _stateRx = RxNotifier(JoystickState.empty(size));
  }
  final _loadingRx = RxNotifier(false);
  bool get isLoading => _loadingRx.value;
  void setLoading(bool value) => _loadingRx.value = value;

  RxNotifier _stateRx;
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

  // void calculatePosition(double x, double y, double radius) {
  //   double newX, newY;
  //   final isExternalOfCircunference = x * x + y * y > radius * radius;
  //   while (isExternalOfCircunference) {
  //     newX = (x > 0) ? x - 1 : x + 1;
  //     newY = (y > 0) ? y - 1 : y + 1;
  //   }
  //   update(state.copyWith(x: newX, y: newY));
  // }

  void dispose() {
    _loadingRx.dispose();
    _stateRx.dispose();
    _errorRx.dispose();
  }
}
