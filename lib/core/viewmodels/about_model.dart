import 'package:package_info/package_info.dart';

import '../../core/services/link_service.dart';
import '../../locator.dart';
import '../enums/viewstate.dart';
import 'base_model.dart';

class AboutModel extends BaseModel {
  final LinkService _linkService = locator<LinkService>();

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  void init() async {
    await _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    setStateView(ViewState.Busy);
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
    setStateView(ViewState.Idle);
  }

  void openLink(String link) {
    _linkService.open(link);
  }
}
