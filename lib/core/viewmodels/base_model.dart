import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import '../../core/util/logger.dart';
import '../enums/viewstate.dart';

class BaseModel extends ChangeNotifier {
  static const String STATE_VIEW = 'viewState';
  static const String STATE_MESSAGE = 'viewMessage';

  final Logger _logger = getLogger();

  bool _isDisposed = false;

  Map<String, Object> _stateMap = {STATE_VIEW: ViewState.Idle, STATE_MESSAGE: null};

  ViewState get state => _stateMap[STATE_VIEW];

  String get stateMessage => _stateMap[STATE_MESSAGE];

  void setStateValue(String key, Object stateValue) {
    if (_stateMap.containsKey(key)) {
      _stateMap.update(key, (value) => stateValue);
    } else {
      _stateMap.putIfAbsent(key, () => stateValue);
    }

    if (!_isDisposed) {
      notifyListeners();
      _logger.d("Notified state value update '($key, ${stateValue.toString()})'");
    }
  }

  void removeStateValue(String key) {
    _stateMap.remove(key);

    if (!_isDisposed) {
      notifyListeners();
      _logger.d("Notified state removal of '$key'");
    }
  }

  void setStateView(ViewState stateView) {
    setStateValue(STATE_VIEW, stateView);
  }

  void setStateMessage(String stateMessage) {
    setStateValue(STATE_MESSAGE, stateMessage);
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
