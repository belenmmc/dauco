import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/data/services/user_service.dart';
import 'package:dauco/domain/usercases/login_use_case.dart';
import 'package:injector/injector.dart';

final appInjector = Injector.appInstance;

void initInjection() {
  appInjector.registerSingleton<UserService>(() => UserService());

  appInjector.registerSingleton<UserRepository>(
      () => UserRepository(userService: appInjector.get<UserService>()));

  appInjector.registerSingleton<LoginUseCase>(
      () => LoginUseCase(userRepository: appInjector.get<UserRepository>()));
}
