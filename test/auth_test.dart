
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/views/authenticate/sign_in.dart';

class MockAuth extends Mock implements AuthService {}
class MockFirebaseUser extends Mock implements FirebaseUser {}
void main() {
  group('Firebase Authentication Test', (){
    test('non-empty email and password, valid account, call sign in, succeed', () async{
      MockAuth mockauth = MockAuth();
      MockFirebaseUser firebaseuser = MockFirebaseUser();
      when(mockauth.signInWithEmailAndPassword('email', 'password')).thenAnswer((_) => Future<MockFirebaseUser>.value(firebaseuser));
      expect(await mockauth.signInWithEmailAndPassword('email', 'password'), firebaseuser);
      verify(mockauth.signInWithEmailAndPassword('email', 'password')).called(1);
    });

    test('non-empty email and password, valid account, call sign in, fails', () async{
      MockAuth mockauth = MockAuth();
      when(mockauth.signInWithEmailAndPassword('email', 'password')).thenAnswer((_) => Future.value(null));
      expect(await mockauth.signInWithEmailAndPassword('email', 'password'), null);
      verify(mockauth.signInWithEmailAndPassword('email', 'password')).called(1);
    });

    test('valid signout on user object', () async{
      MockAuth mockauth = MockAuth();
      await mockauth.signOut();
      verify(mockauth.signOut()).called(1);
    });

    test('invalid signout in user object', () async{
      MockAuth mockauth = MockAuth();
      when(mockauth.signOut()).thenAnswer((_) => Future.value(null));
      expect(await mockauth.signOut(),null);
      verify(mockauth.signOut()).called(1);
    });
    
    test('reset password on valid email address', ()async{
      MockAuth mockauth = MockAuth();
      when(mockauth.resetPassword('email')).thenAnswer((_) => Future.value(true));
      expect(await mockauth.resetPassword('email'), true);
      verify(mockauth.resetPassword('email')).called(1);
    });

    test('reset password on invalid email address', ()async{
      MockAuth mockauth = MockAuth();
      when(mockauth.resetPassword('email')).thenAnswer((_) => Future.value(false));
      expect(await mockauth.resetPassword('email'), false);
      verify(mockauth.resetPassword('email')).called(1);
    });
  });

  group('Authentication Form Fields Validator Test', (){
    test('empty email returns error string', () {
    final result = EmailFieldValidator.validate('');
    expect(result, 'Enter an email address');
    });

    test('non-empty email returns null', () {
      final result = EmailFieldValidator.validate('email');
      expect(result, null);
    });

    test('empty password returns error string', () {
      final result = PasswordFieldValidator.validate('');
      expect(result, 'Enter a password');
    });

    test('non-empty password returns null', () {
      final result = PasswordFieldValidator.validate('password');
      expect(result, null);
    });

    test('empty reset email returns error string', () {
    final result = EmailFieldValidator.validate('');
    expect(result, 'Enter an email address');
    });

    test('non-empty reset email returns null', () {
      final result = EmailFieldValidator.validate('email');
      expect(result, null);
    });

  });

}
