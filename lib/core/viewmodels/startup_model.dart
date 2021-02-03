import 'package:flutter_translate/flutter_translate.dart';

import '../../locator.dart';
import '../../ui/views/home_view.dart';
import '../enums/viewstate.dart';
import '../services/navigation_service.dart';
import '../services/session_service.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final SessionService _sessionService = locator<SessionService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    setState(ViewState.Busy);
    setStateMessage(translate('startup.init'));
    await Future.delayed(Duration(milliseconds: 150));

    setStateMessage(translate('startup.start_services'));
    await _sessionService.start();
    await Future.delayed(Duration(milliseconds: 150));

    _navigationService.navigateAndReplaceTo(HomeView.routeName);

    setState(ViewState.Idle);
  }
}
