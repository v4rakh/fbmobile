import 'package:get_it/get_it.dart';

import 'core/repositories/file_repository.dart';
import 'core/services/api.dart';
import 'core/services/dialog_service.dart';
import 'core/services/file_service.dart';
import 'core/services/link_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/session_service.dart';
import 'core/services/storage_service.dart';
import 'core/viewmodels/about_model.dart';
import 'core/viewmodels/history_model.dart';
import 'core/viewmodels/home_model.dart';
import 'core/viewmodels/login_model.dart';
import 'core/viewmodels/profile_model.dart';
import 'core/viewmodels/startup_model.dart';
import 'core/viewmodels/upload_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /// app helper services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => DialogService());

  /// api + data repositories
  locator.registerLazySingleton(() => Api());

  locator.registerLazySingleton(() => FileRepository());

  /// services
  locator.registerLazySingleton(() => SessionService());
  locator.registerLazySingleton(() => FileService());
  locator.registerLazySingleton(() => LinkService());
  locator.registerLazySingleton(() => PermissionService());

  /// view models
  locator.registerFactory(() => StartUpViewModel());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => AboutModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => UploadModel());
  locator.registerFactory(() => HistoryModel());
  locator.registerFactory(() => ProfileModel());
}
