import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/authenticate/resetPassword.dart';
import 'package:tpfs_policeman/views/authenticate/sign_in.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';
import 'package:tpfs_policeman/wrapper.dart';

class MockAuth extends Mock implements AuthService {}
class MockFirebaseUser extends Mock implements FirebaseUser {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {

  group('Test wrapper widget', (){
    Widget makeTestableWidgetWrapper({Widget child,User user}) {
      return Provider<User>.value(
        value: user,
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('Wrapper Returns Correct Widget', (WidgetTester tester) async {
      Wrapper wrapperwidget = Wrapper();
      await tester.pumpWidget(makeTestableWidgetWrapper(child:wrapperwidget,user: null));
      expect(find.byKey(Key('HomePage')), findsNothing);
      expect(find.byKey(Key('Authenticate')), findsOneWidget);
      await tester.pumpWidget(makeTestableWidgetWrapper(child:wrapperwidget,user: User(uid:'oepshkqjhk2368')));
      expect(find.byKey(Key('HomePage')), findsOneWidget);
      expect(find.byKey(Key('Authenticate')), findsNothing);
    });
  });

  group('Testing the sign in widget', (){
    Widget makeTestableWidgetSignIN({Widget child}) {
    return MaterialApp(
      home: child,
    );
    }

    Widget signInWithNavigation({Widget child,mockobservers}) {
    return MaterialApp(
      home: child,
      navigatorObservers: [mockobservers],
    );
    }
    testWidgets('Verify widgets in ui when navigated', (WidgetTester tester) async {
      SignIn signInwidget = SignIn();
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      expect(find.byKey(Key('Loading')), findsNothing);
      expect(find.byKey(Key('SignInAuthenticate')), findsOneWidget);
      expect(find.byKey(Key('SignInAppbar')), findsOneWidget);
      expect(find.byKey(Key('SignInAppText')), findsOneWidget);
      expect(find.byKey(Key('SignInEmail')), findsOneWidget);
      expect(find.byKey(Key('SignInPassword')), findsOneWidget);
      expect(find.byKey(Key('SignInButton')), findsOneWidget);
      expect(find.byKey(Key('ForgetPasswordButton')), findsOneWidget);
      expect(find.byKey(Key('SignInErrorText')), findsOneWidget);
    });

    testWidgets('Sign in with email and password fields empty', (WidgetTester tester) async{
      MockAuth mockauth = MockAuth();
      SignIn signInwidget = SignIn(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      await tester.tap(find.byKey(Key('SignInButton')));
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      verifyNever(mockauth.signInWithEmailAndPassword('', ''));
      expect(find.text('Enter an email address'), findsOneWidget);
      expect(find.text('Enter a password'), findsOneWidget);
    });

    testWidgets('non-empty email and password, in valid account, call sign in, fails', (WidgetTester tester) async{
      MockAuth mockauth = MockAuth();
      // MockFirebaseUser firebaseuser = MockFirebaseUser();
      when(mockauth.signInWithEmailAndPassword('email', 'password')).thenAnswer((_) => Future.value(null));
      // when(mockauth.signInWithEmailAndPassword('email', 'password')).thenAnswer((_) => Future<MockFirebaseUser>.value(firebaseuser));
      SignIn signInwidget = SignIn(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      Finder emailField = find.byKey(Key('SignInEmail'));
      await tester.enterText(emailField, 'email');
      Finder passwordField = find.byKey(Key('SignInPassword'));
      await tester.enterText(passwordField, 'password');
      await tester.tap(find.byKey(Key('SignInButton')));
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      verify(mockauth.signInWithEmailAndPassword('email', 'password')).called(1);
      expect(find.text('Could not sign in with those credentials'), findsOneWidget);
      expect(find.byKey(Key('Loading')), findsNothing);
    });

    testWidgets('non-empty email and password, valid account, call sign success', (WidgetTester tester) async{
      MockAuth mockauth = MockAuth();
      MockFirebaseUser firebaseuser = MockFirebaseUser();
      when(mockauth.signInWithEmailAndPassword('email', 'password')).thenAnswer((_) => Future<MockFirebaseUser>.value(firebaseuser));
      SignIn signInwidget = SignIn(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      Finder emailField = find.byKey(Key('SignInEmail'));
      await tester.enterText(emailField, 'email');
      Finder passwordField = find.byKey(Key('SignInPassword'));
      await tester.enterText(passwordField, 'password');
      await tester.tap(find.byKey(Key('SignInButton')));
      await tester.pumpWidget(makeTestableWidgetSignIN(child : signInwidget));
      verify(mockauth.signInWithEmailAndPassword('email', 'password')).called(1);
      expect(find.text('Could not sign in with those credentials'), findsNothing);
      expect(find.byKey(Key('Loading')), findsOneWidget);
    });

    testWidgets('Test Navigation to ResetPassword page', (WidgetTester tester) async {
      MockAuth mockauth = MockAuth();
      SignIn signInwidget = SignIn(auth: mockauth);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(signInWithNavigation(child : signInwidget,mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('ForgetPasswordButton')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('ResetPassword')), findsOneWidget);
    });  
  });
    
  group('Test Reset Password widget', (){
    Widget makeTestableWidgetResetPassword({Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    Widget resetPasswordWithNavigation({Widget child,mockobservers}) {
      return MaterialApp(
        home: child,
        navigatorObservers: [mockobservers],
      );
    }

    testWidgets('Verify widgets in UI When Navigated', (WidgetTester tester) async{
      ResetPassword resetPasswordWidget = ResetPassword();
      await tester.pumpWidget(makeTestableWidgetResetPassword(child:resetPasswordWidget));
      expect(find.byKey(Key('EmailSent')), findsNothing);
      expect(find.byKey(Key('ResetPasswordAppbar')), findsOneWidget);
      expect(find.byKey(Key('ResetPasswordApptext')), findsOneWidget);
      expect(find.byKey(Key('ResetEmail')), findsOneWidget);
      expect(find.byKey(Key('SendResetEmailButton')), findsOneWidget);
      expect(find.byKey(Key('IsMessage')), findsNothing);
      expect(find.byKey(Key('IsASuccess')), findsOneWidget);
      expect(find.byKey(Key('IsNotSuccess')), findsNothing);
      expect(find.byKey(Key('ReturnButton')), findsOneWidget);
    });

    testWidgets('Email address empty', (WidgetTester tester) async {
      MockAuth mockauth = MockAuth();
      // when(mockauth.resetPassword('email')).thenAnswer((_) => Future.value(true));
      ResetPassword resetPasswordWidget = ResetPassword(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetResetPassword(child:resetPasswordWidget));
      await tester.tap(find.byKey(Key('SendResetEmailButton')));
      await tester.pumpWidget(makeTestableWidgetResetPassword(child : resetPasswordWidget));
      verifyNever(mockauth.resetPassword(''));
      expect(find.text('Enter an email address'), findsOneWidget);
    });

    testWidgets('non-empty email address email sent, Success', (WidgetTester tester) async {
      MockAuth mockauth = MockAuth();
      when(mockauth.resetPassword('email')).thenAnswer((_) => Future.value(true));
      ResetPassword resetPasswordWidget = ResetPassword(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetResetPassword(child:resetPasswordWidget));
      Finder emailField = find.byKey(Key('ResetEmail'));
      await tester.enterText(emailField, 'email');
      await tester.tap(find.byKey(Key('SendResetEmailButton')));
      await tester.pumpWidget(makeTestableWidgetResetPassword(child : resetPasswordWidget));
      verify(mockauth.resetPassword('email')).called(1);
      expect(find.text('An email with reset password link has been sent'), findsOneWidget);
      expect(find.byKey(Key('IsASuccess')), findsOneWidget);
      expect(find.byKey(Key('IsNotSuccess')), findsNothing);
      expect(find.byKey(Key('EmailSent')), findsOneWidget);
      expect(find.byKey(Key('ResetEmail')), findsNothing);
      expect(find.byKey(Key('SendEmailButton')), findsNothing);
      expect(find.byKey(Key('IsMessage')), findsOneWidget);
    });

    testWidgets('non-empty email address email sent, call fail', (WidgetTester tester) async {
      MockAuth mockauth = MockAuth();
      when(mockauth.resetPassword('email')).thenAnswer((_) => Future.value(false));
      ResetPassword resetPasswordWidget = ResetPassword(auth: mockauth);
      await tester.pumpWidget(makeTestableWidgetResetPassword(child:resetPasswordWidget));
      Finder emailField = find.byKey(Key('ResetEmail'));
      await tester.enterText(emailField, 'email');
      await tester.tap(find.byKey(Key('SendResetEmailButton')));
      await tester.pumpWidget(makeTestableWidgetResetPassword(child : resetPasswordWidget));
      verify(mockauth.resetPassword('email')).called(1);
      expect(find.text('Account Not Found TRY AGAIN'), findsOneWidget);
      expect(find.byKey(Key('IsASuccess')), findsNothing);
      expect(find.byKey(Key('IsNotSuccess')), findsOneWidget);
      expect(find.byKey(Key('IsNotSuccessMessage')), findsOneWidget);
      expect(find.byKey(Key('EmailSent')), findsNothing);
      expect(find.byKey(Key('ResetEmail')), findsOneWidget);
      expect(find.byKey(Key('SendResetEmailButton')), findsOneWidget);
      expect(find.byKey(Key('IsMessage')), findsNothing);
    });

    testWidgets('Test Navigation to ResetPassword page', (WidgetTester tester) async {
      MockAuth mockauth = MockAuth();
      ResetPassword resetPasswordWidget = ResetPassword(auth: mockauth);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(resetPasswordWithNavigation(child : resetPasswordWidget,mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('ReturnButton')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      // expect(find.byKey(Key('SignIN')), findsOneWidget);
    }); 
  });
  
  
}
