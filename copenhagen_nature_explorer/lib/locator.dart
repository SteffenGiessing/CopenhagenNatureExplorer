import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';
import 'package:copenhagen_nature_explorer/repository/mapHelper_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/repository/firestore_repo.dart';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:copenhagen_nature_explorer/view_controller/post_controller.dart';
import 'package:copenhagen_nature_explorer/repository/direction_repo.dart';
import 'package:get_it/get_it.dart';

/*
  The service locator class where i will register my services as singleton.
*/

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<DirectionsRepository>(DirectionsRepository());
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<FirestoreRepo>(FirestoreRepo());
  locator.registerSingleton<DirectionHelper>(DirectionHelper());
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<PostController>(PostController());
  locator.registerSingleton<MarkersController>(MarkersController());
}
