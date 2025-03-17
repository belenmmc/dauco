import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/data/services/user_service.dart';
import 'package:dauco/domain/usecases/get_minors_use_case.dart';
import 'package:dauco/domain/usecases/get_tests_use_case.dart';
import 'package:dauco/domain/usecases/import_users_use_case.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:injector/injector.dart';

final appInjector = Injector.appInstance;

void initInjection() {
  appInjector.registerSingleton<UserService>(() => UserService());

  appInjector.registerSingleton<ImportService>(() => ImportService());

  appInjector.registerSingleton<UserRepository>(
      () => UserRepository(userService: appInjector.get<UserService>()));

  appInjector.registerSingleton<LoginUseCase>(
      () => LoginUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<ImportRepository>(
      () => ImportRepository(importService: appInjector.get<ImportService>()));

  appInjector.registerSingleton<LoadFileUseCase>(() =>
      LoadFileUseCase(importRepository: appInjector.get<ImportRepository>()));

  appInjector.registerSingleton<ImportUsersUseCase>(() => ImportUsersUseCase(
      importRepository: appInjector.get<ImportRepository>()));

  appInjector.registerSingleton<GetMinorsUseCase>(() =>
      GetMinorsUseCase(importRepository: appInjector.get<ImportRepository>()));

  appInjector.registerSingleton<GetTestsUseCase>(() =>
      GetTestsUseCase(importRepository: appInjector.get<ImportRepository>()));
}
