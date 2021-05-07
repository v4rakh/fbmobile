import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/dialog_service.dart';
import '../../core/util/logger.dart';
import '../../locator.dart';

class LinkService {
  final Logger _logger = getLogger();
  final DialogService _dialogService = locator<DialogService>();

  Future open(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      _logger.e('Could not launch link $link');
      _dialogService.showDialog(
          title: translate('link.dialog.title'),
          description: translate('link.dialog.description', args: {'link': link}));
    }
  }
}
