import '../../core/services/link_service.dart';
import '../../locator.dart';
import 'base_model.dart';

class AboutModel extends BaseModel {
  final LinkService _linkService = locator<LinkService>();

  void openLink(String link) {
    _linkService.open(link);
  }
}
