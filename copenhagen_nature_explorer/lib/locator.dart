import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';
import 'package:copenhagen_nature_explorer/repository/register_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/view_controller/register_controller.dart';
import 'package:copenhagen_nature_explorer/view_controller/user_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  //locator.registerSingleton<RegisterRepo>(RegisterRepo());
  locator.registerSingleton<UserController>(UserController());
  //locator.registerSingleton<RegisterController>(RegisterController());
}
