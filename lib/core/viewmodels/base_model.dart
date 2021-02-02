import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import '../../core/util/logger.dart';
import '../enums/viewstate.dart';

class BaseModel extends ChangeNotifier {
  final Logger _logger = getLogger();

  bool _isDisposed = false;

  ViewState _state = ViewState.Idle;
  String _stateMessage;

  ViewState get state => _state;

  String get stateMessage => _stateMessage;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!_isDisposed) {
      notifyListeners();
      _logger.d("Notified state change '${viewState.toString()}'");
    }
  }

  void setStateMessage(String stateMessage) {
    _stateMessage = stateMessage;
    if (!_isDisposed) {
      notifyListeners();
      _logger.d("Notified state message change '$stateMessage'");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
