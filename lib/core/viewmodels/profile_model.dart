import 'package:flutter_translate/flutter_translate.dart';

import '../../core/services/session_service.dart';
import '../../locator.dart';
import '../services/dialog_service.dart';
import '../services/link_service.dart';
import 'base_model.dart';

class ProfileModel extends BaseModel {
  final SessionService _sessionService = locator<SessionService>();
  final DialogService _dialogService = locator<DialogService>();
  final LinkService _linkService = locator<LinkService>();

  Future logout() async {
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: translate('logout.title'), description: translate('logout.confirm'));

    if (dialogResult.confirmed) {
      await _sessionService.logout();
    }
  }

  Future revealApiKey(String apiKey) async {
    await _dialogService.showDialog(
        title: translate('profile.revealed_api_key.title'),
        description: translate('profile.revealed_api_key.description', args: {'apiKey': apiKey}));
  }

  void openLink(String link) {
    _linkService.open(link);
  }
}
