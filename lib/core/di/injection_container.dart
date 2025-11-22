/// Dependency Injection Container
///
/// This file contains the setup for all dependency injection using GetIt.
/// All services, data sources, repositories, and cubits are registered here.
/// Call setupGetIt() in main.dart before runApp().

import 'package:firebase_auth/firebase_auth.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/auth/data/datasources/auth_firebase_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import '../../features/settings/data/datasources/device_data_source.dart';
import '../../features/settings/data/repositories/device_repository.dart';
import '../../features/settings/presentation/cubits/settings_cubit/settings_cubit.dart';
import '../services/local_storage_service.dart';

final getIt = GetIt.instance;

/// Setup all dependencies
/// Must be called before runApp() in main.dart
Future<void> setupGetIt() async {
  // Core Services
  getIt.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Initialize LocalStorageService
  await getIt<LocalStorageService>().init();

  // Auth Feature - Data Layer
  getIt.registerLazySingleton<AuthFirebaseDataSource>(
    () => AuthFirebaseDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authFirebaseDataSource: getIt<AuthFirebaseDataSource>(),
    ),
  );

  // Auth Feature - Presentation Layer
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(authRepository: getIt<AuthRepository>()),
  );

  // Settings Feature - Data Layer
  getIt.registerLazySingleton<DeviceDataSource>(() => DeviceDataSourceImpl());

  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(deviceDataSource: getIt<DeviceDataSource>()),
  );

  // Settings Feature - Presentation Layer
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<DeviceRepository>()),
  );
}
