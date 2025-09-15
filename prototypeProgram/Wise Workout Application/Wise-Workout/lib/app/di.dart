
import '../services/auth_service_mock.dart';
import '../usecases/auth_usecase.dart';
import '../usecases/profile_usecase.dart';
import '../usecases/workout_usecase.dart';

class DI {
  final AuthServiceMock auth;
  late final AuthUseCase authUseCase = AuthUseCase(auth);
  late final ProfileUseCase profileUseCase = ProfileUseCase(auth);
  late final WorkoutUseCase workoutUseCase = WorkoutUseCase();
  DI({required this.auth});
}
