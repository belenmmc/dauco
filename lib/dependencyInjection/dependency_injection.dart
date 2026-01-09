import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/data/repositories/implementation/item_repository.dart';
import 'package:dauco/data/repositories/implementation/minor_repository.dart';
import 'package:dauco/data/repositories/implementation/test_repository.dart';
import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/data/services/import_service.dart';
import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/data/services/item_service.dart';
import 'package:dauco/data/services/minor_service.dart';
import 'package:dauco/data/services/test_service.dart';
import 'package:dauco/data/services/user_service.dart';
import 'package:dauco/domain/usecases/delete_minor_use_case.dart';
import 'package:dauco/domain/usecases/delete_user_use_case.dart';
import 'package:dauco/domain/usecases/get_all_users_use_case.dart';
import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/domain/usecases/get_imported_user_use_case.dart';
import 'package:dauco/domain/usecases/update_imported_user_use_case.dart';
import 'package:dauco/domain/usecases/validate_manager_id_use_case.dart';
import 'package:dauco/domain/usecases/get_all_items_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_for_export_use_case.dart';
import 'package:dauco/domain/usecases/get_all_tests_use_case.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:dauco/domain/usecases/logout_use_case.dart';
import 'package:dauco/domain/usecases/pick_file_use_case.dart';
import 'package:dauco/domain/usecases/register_use_case.dart';
import 'package:dauco/domain/usecases/reset_password_use_case.dart';
import 'package:dauco/domain/usecases/update_minor_use_case.dart';
import 'package:dauco/domain/usecases/update_password_use_case.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:dauco/domain/usecases/export_minor_use_case.dart';
import 'package:injector/injector.dart';

final appInjector = Injector.appInstance;

void initInjection() {
  appInjector.registerSingleton<UserService>(() => UserService());

  appInjector.registerSingleton<ImportService>(() => ImportService());

  appInjector
      .registerSingleton<ImportedUserService>(() => ImportedUserService());

  appInjector.registerSingleton<MinorService>(() => MinorService());

  appInjector.registerSingleton<TestService>(() => TestService());

  appInjector.registerSingleton<ItemService>(() => ItemService());

  appInjector.registerSingleton<UserRepository>(
      () => UserRepository(userService: appInjector.get<UserService>()));

  appInjector.registerSingleton<ImportRepository>(
      () => ImportRepository(importService: appInjector.get<ImportService>()));

  appInjector.registerSingleton<MinorRepository>(
      () => MinorRepository(minorService: appInjector.get<MinorService>()));

  appInjector.registerSingleton<TestRepository>(
      () => TestRepository(testService: appInjector.get<TestService>()));

  appInjector.registerSingleton<ItemRepository>(
      () => ItemRepository(itemService: appInjector.get<ItemService>()));

  appInjector.registerSingleton<LoginUseCase>(
      () => LoginUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<LogoutUseCase>(
      () => LogoutUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<GetCurrentUserUseCase>(() =>
      GetCurrentUserUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<DeleteUserUseCase>(() =>
      DeleteUserUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<UpdateUserUseCase>(() =>
      UpdateUserUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<GetAllUsersUseCase>(() =>
      GetAllUsersUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<RegisterUseCase>(
      () => RegisterUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<ResetPasswordUseCase>(() =>
      ResetPasswordUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<UpdatePasswordUseCase>(() =>
      UpdatePasswordUseCase(userRepository: appInjector.get<UserRepository>()));

  appInjector.registerSingleton<PickFileUseCase>(() =>
      PickFileUseCase(importRepository: appInjector.get<ImportRepository>()));

  appInjector.registerSingleton<LoadFileUseCase>(() =>
      LoadFileUseCase(importRepository: appInjector.get<ImportRepository>()));

  appInjector.registerSingleton<GetAllMinorsUseCase>(() =>
      GetAllMinorsUseCase(minorRepository: appInjector.get<MinorRepository>()));

  appInjector.registerSingleton<GetAllMinorsForExportUseCase>(() =>
      GetAllMinorsForExportUseCase(
          minorRepository: appInjector.get<MinorRepository>()));

  appInjector.registerSingleton<UpdateMinorUseCase>(() =>
      UpdateMinorUseCase(minorRepository: appInjector.get<MinorRepository>()));

  appInjector.registerSingleton<DeleteMinorUseCase>(() =>
      DeleteMinorUseCase(minorRepository: appInjector.get<MinorRepository>()));

  appInjector.registerSingleton<GetAllTestsUseCase>(() =>
      GetAllTestsUseCase(testRepository: appInjector.get<TestRepository>()));

  appInjector.registerSingleton<GetAllItemsUseCase>(() =>
      GetAllItemsUseCase(itemRepository: appInjector.get<ItemRepository>()));

  appInjector.registerSingleton<ExportMinorUseCase>(() => ExportMinorUseCase());

  // Imported User use cases
  appInjector.registerSingleton<GetImportedUserUseCase>(() =>
      GetImportedUserUseCase(
          importedUserService: appInjector.get<ImportedUserService>()));

  appInjector.registerSingleton<UpdateImportedUserUseCase>(() =>
      UpdateImportedUserUseCase(
          importedUserService: appInjector.get<ImportedUserService>()));

  appInjector.registerSingleton<ValidateManagerIdUseCase>(() =>
      ValidateManagerIdUseCase(
          importedUserService: appInjector.get<ImportedUserService>()));
}
