
import '../services/auth_service_mock.dart';

class ProfileUseCase {
  final AuthServiceMock _auth;
  ProfileUseCase(this._auth);

  Future<void> viewProfile() async {}
  Future<void> updateProfile({required String displayName}) async {}
  Future<void> updateFitnessGoal({required String goal}) async {}
  Future<void> pairWithWearableDevice() async {}
  Future<void> linkSocialMediaAccount({required String provider}) async {}
}
