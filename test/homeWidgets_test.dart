import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'authWidgets_test.dart';

class StorageMock extends Mock implements Storage {}
class MockPolice extends Mock implements DatabaseServicePolicemen {}
class MockDocumentReference extends Mock implements DocumentReference {}
void main(){
  group('HomePage Testing Navigation Bar Testing', (){

    Widget makeTestableWidgetMainHome({Widget child,User user}) {
      return Provider<User>.value(
          value:user,
          child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('Load Main HomePage widgets intially', (WidgetTester tester) async{
      StorageMock mockStorage = StorageMock();
      MockPolice mockpolice = MockPolice();
      HomePage homepagewidget = HomePage(storage: mockStorage,policeUser: mockpolice);
      User usermock = User(uid:'3961jflh3482');
      await tester.pumpWidget(makeTestableWidgetMainHome(child : homepagewidget,user:usermock));
      expect(find.byKey(Key('HomeAppbar')), findsOneWidget);
      expect(find.byKey(Key('HomeApptext')), findsOneWidget);
      expect(find.byKey(Key('SignoutButton')), findsOneWidget);
      expect(find.byKey(Key('BottomNavigation')), findsOneWidget);
      expect(find.byKey(Key('MainInfoHome')), findsOneWidget);
      expect(find.byKey(Key('TicketIconHome')), findsOneWidget);
      expect(find.byKey(Key('CreateTicketText')), findsOneWidget);
      expect(find.byKey(Key('StartProcedureText')), findsOneWidget);
      expect(find.byKey(Key('StartProcedureButton')), findsOneWidget);
      expect(find.byKey(Key('NotificationList')), findsNothing);
      expect(find.byKey(Key('UserProfileTab')), findsNothing);
      expect(find.byKey(Key('Home')), findsOneWidget);

    });

    testWidgets('Tap Bottom Navigation Bar- Notification', (WidgetTester tester) async{
      StorageMock mockStorage = StorageMock();
      MockPolice mockpolice = MockPolice();
      HomePage homepagewidget = HomePage(storage: mockStorage,policeUser: mockpolice);
      User usermock = User(uid:'3961jflh3482');
      await tester.pumpWidget(makeTestableWidgetMainHome(child : homepagewidget,user:usermock));
      await tester.tap(find.text('MESSAGES'));
      await tester.pumpWidget(makeTestableWidgetMainHome(child : homepagewidget,user:usermock));
      expect(find.byKey(Key('NotificationList')), findsOneWidget);
      expect(find.byKey(Key('NotificationListBuilder')), findsOneWidget);
      expect(find.byKey(Key('UserProfileTab')), findsNothing);
      expect(find.byKey(Key('Home')), findsNothing);
    });

    testWidgets('Tap Bottom Navigation Bar- Profile', (WidgetTester tester) async{
      StorageMock mockStorage = StorageMock();
      MockPolice mockpolice = MockPolice();
      when(mockStorage.getUserImage('3961jflh3482')).thenAnswer((_) => Future.value('Some-url'));
      HomePage homepagewidget = HomePage(storage: mockStorage,policeUser: mockpolice);
      User usermock = User(uid:'3961jflh3482');
      await tester.pumpWidget(makeTestableWidgetMainHome(child : homepagewidget,user:usermock));
      await tester.tap(find.text('PROFILE'));
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetMainHome(child : homepagewidget,user:usermock)));
      expect(find.byKey(Key('NotificationList')), findsNothing);
      expect(find.byKey(Key('UserProfileTab')), findsOneWidget);
      expect(find.byKey(Key('Home')), findsNothing);
      verify(mockStorage.getUserImage('3961jflh3482')).called(1);
    });
  });

  group('HomePage Navigation to fineProcedure', (){
    Widget makeTestableNavigationMainHome({Widget child,User user,mockobservers}) {
      return Provider<User>.value(
          value:user,
          child: MaterialApp(
          home: child,
          navigatorObservers: [mockobservers],
        ),
      );
    }
    testWidgets('Click on Start Procedure', (WidgetTester tester) async{
      StorageMock mockStorage = StorageMock();
      MockPolice mockpolice = MockPolice();
      MockDocumentReference docRef = MockDocumentReference();
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: 'kdhf84dbsbf');
      when(mockpolice.createProcedure(procedureNew)).thenAnswer((_) => Future<MockDocumentReference>.value(docRef));
      HomePage homepagewidget = HomePage(storage: mockStorage,policeUser: mockpolice);
      User usermock = User(uid:'3961jflh3482');
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableNavigationMainHome(child : homepagewidget,user:usermock,mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('StartProcedureButton')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('FineProcedure')), findsOneWidget);
    });
  });
}