import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:copenhagen_nature_explorer/view_controller/post_controller.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<FirebaseRepo>(FirebaseRepo());
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<PostController>(PostController());
  locator.registerSingleton<MarkersController>(MarkersController());
}
