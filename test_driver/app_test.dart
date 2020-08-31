// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('PoliceMen App', () {

    final emailFieldTextFinder = find.byValueKey('SignInEmail');
    final passwordFieldTextFinder = find.byValueKey('SignInPassword');
    final notificationTileFinder = find.byValueKey('NotificationTile');
    final notificationListFinder = find.byValueKey('NotificationListBuilder');
    final resetemailFieldTextFinder = find.byValueKey('ResetEmail');
    final signInbuttonFinder = find.byValueKey('SignInButton');
    final resetmailprofilebuttonFinder = find.byValueKey('hasreset');
    final notificationsTabFinder = find.text('MESSAGES');
    final profileTabFinder = find.text('PROFILE');
    final vehicleProfilesSearchGrid = find.byValueKey('VehcileProfile');
    final driverProfileSearchGrid = find.byValueKey('DriverProfile');
    final criminalAssessmentGrid = find.byValueKey('CA');
    final createTicketGrid = find.byValueKey('TicketCreation');
    final startprocedurebutton = find.byValueKey('StartProcedureButton');
    final finishprocedurebutton = find.byValueKey('EndProcedureButton');
    final goBackVehicleButton = find.byValueKey('goBackVehicle');
    final changepasswordtab = find.byValueKey('HasChangePassword');
    final returntoprofilebutton = find.byValueKey('ReturnProfileButton');
    final notchangepasswordtab = find.byValueKey('NotChangePassword');
    final resetbuttonFinder = find.byValueKey('ForgetPasswordButton');
    final resetMailSendFinder = find.byValueKey('SendResetEmailButton');
    final addTicketImageButton = find.byValueKey('addticketimagebutton');
    final driverTicketAddDialog = find.byValueKey('dialogaddticketimage');
    final driverTicketAddButton = find.byValueKey('addticketcontinuebutton');
    final driverTicketCancelButton = find.byValueKey('addticketcancelbutton');
    final returntoSignInbuttonFinder = find.byValueKey('ReturnButton');
    final signOutFinder = find.byValueKey('SignoutButton');
    final homePage = find.byValueKey('HomePage');
    final procedurePage = find.byValueKey('FineProcedure');
    final vehicleSearchPage =find.byValueKey('SearchVehicle');
    final driverSearchPage = find.byValueKey('SearchDriver');
    final vehicleResultPage = find.byValueKey('vehicleresult');
    final driverResultPage = find.byValueKey('DriverProfilePage');
    final vehicleOffencePage = find.byValueKey('vehicleOffences');
    final searchvehiclebar = find.byValueKey('SearchBarVehicle');
    final searchdriverbar = find.byValueKey('SearchBarDriver');
    final vehicleResultPresent = find.byValueKey('SearchResultTile');
    final noVehiclePresent = find.byValueKey('NoResultsText');
    final cameraDriverScreen = find.byValueKey('TakePictureDriver');
    final driverAddbutton = find.byValueKey('DriverAddButton');
    final cameraAddButton = find.byValueKey('PictureTakeButton');
    final driverAdddialog = find.byValueKey('AddPictureLicensePlate');
    final driverAddContinueButton = find.byValueKey('DriverAddContinue');
    final driverAddCancelButton = find.byValueKey('DriverAddCancel');
    final pictureTicketDriverPage = find.byValueKey('TicketDriver');
    final cancelsearchButton = find.byValueKey('CancelWidget');
    final signInPage = find.byValueKey('SignIN');
    final viewOffencesButton = find.byValueKey('ViewOffencesButton');
    final resetPasswordPage = find.byValueKey('ResetPassword');
    final emailEmptyText = find.text('Enter an email address');
    final passwordEmptyText = find.text('Enter a password');
    final noHistory = find.byValueKey('nooutHistory');
    final paidTicketHistory = find.byValueKey('paidHistory');
    final paidticketstab = find.byValueKey('Paid');
    final paidtickettile = find.byValueKey('tile1');
    final licenseNumberTicket = find.text('53388233BH');
    final licensePlateTicket = find.text('KI-8407');
    final phoneNumberTicketField = find.byValueKey('phoneFieldVal');
    final liceneplateField = find.byValueKey('licensefield');
    final resetemailInvalidText = find.text('Account Not Found try again');
    final resetemailValidText = find.text('An email with reset password link has been sent');
    final invalidcredentialsText = find.text('Could not sign in with those credentials');
    final licenseplateEmptyText = find.text('Enter valid license plate number');
    final changeNumberButton = find.byValueKey('ChangeButton');
    final createTicketPageOneButton = find.byValueKey('ContinueTicketButton');
    final caPicturePage = find.byValueKey('TakePicture');
    final caAssessButton = find.byValueKey('CAassessbutton');
    final takePicturePage = find.byValueKey('CameraScreen');
    final filterTicketButton = find.byValueKey('FilterTicketsWidget');
    final choiceFilterTextfind = find.byValueKey('ChoiceSpeeding at 10% above speed limit');
    final filterResetButton = find.byValueKey('ResetButton');
    final createTicketPageTwo = find.byValueKey('CreateTicketPageTwo');
    final addTicketVehiclePage = find.byValueKey('TicketVehicle');
    final closeFilterButton = find.byValueKey('CloseFilterIcon');
    final signoutcancelbutton = find.byValueKey('signoutcancelbutton');
    final signoutModal = find.byValueKey('signoutModal');
    final signoutcontinueButton = find.byValueKey('signoutcontinuebutton');


    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Sign in with email and password fields empty', () async {
      await driver.waitForAbsent(emailEmptyText);
      await driver.waitForAbsent(passwordEmptyText);
      await driver.tap(signInbuttonFinder);
      await Future.delayed(Duration(seconds:3));
      await driver.waitFor(emailEmptyText);
      await driver.waitFor(passwordEmptyText);
      await driver.waitUntilNoTransientCallbacks(); 
      assert(homePage == null); 
    });

    test('non-empty email and password, in valid account, call sign in, fails', () async {
      await driver.tap(emailFieldTextFinder);
      await driver.waitFor(invalidcredentialsText);
      assert(homePage == null);
      await driver.enterText('170307j@tpfs.com');
      await Future.delayed(Duration(seconds:2));      
      await driver.tap(passwordFieldTextFinder);
      await driver.enterText('password');
      await Future.delayed(Duration(seconds:2));
      await driver.tap(signInbuttonFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitForAbsent(emailEmptyText);
      await driver.waitForAbsent(passwordEmptyText);
      await driver.waitFor(invalidcredentialsText);
      await driver.waitUntilNoTransientCallbacks(); 
      assert(homePage == null); 
    });

    test('Reset Email address empty', () async {
      await driver.tap(resetbuttonFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitFor(resetPasswordPage);
      assert(resetPasswordPage != null);
      await driver.waitForAbsent(emailEmptyText);    
      await driver.tap(resetMailSendFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitFor(emailEmptyText);
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Reset Email address wrong, No account found', () async {
      assert(resetPasswordPage != null); 
      await driver.tap(resetemailFieldTextFinder);
      await driver.enterText('170307j@tpfs.com');
      await Future.delayed(Duration(seconds:2));  
      await driver.tap(resetMailSendFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitForAbsent(emailEmptyText);
      await driver.waitFor(resetemailInvalidText);
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Reset Email address valid, Account found', () async {
      assert(resetPasswordPage != null); 
      await driver.tap(resetemailFieldTextFinder);
      await driver.enterText('170454j@tpfs-police.com');
      await Future.delayed(Duration(seconds:2));  
      await driver.tap(resetMailSendFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitForAbsent(emailEmptyText);
      await driver.waitForAbsent(resetemailInvalidText);
      await driver.waitFor(resetemailValidText);
      await driver.tap(returntoSignInbuttonFinder);
      await Future.delayed(Duration(seconds:2));
      await driver.waitFor(signInPage); 
      assert(signInPage != null); 
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Valid account, Sign in, success, Navigate to Notification , Profile - Reset Password', () async {
      await driver.tap(emailFieldTextFinder); await driver.enterText('170454j@tpfs-police.com'); await Future.delayed(Duration(seconds:2));      
      await driver.tap(passwordFieldTextFinder); await driver.enterText('12345678'); await Future.delayed(Duration(seconds:2));
      await driver.tap(signInbuttonFinder); await Future.delayed(Duration(seconds:2)); assert(homePage != null);
      await driver.tap(notificationsTabFinder); await Future.delayed(Duration(seconds:2)); await driver.waitUntilNoTransientCallbacks();
      await driver.waitFor(notificationTileFinder); await driver.waitFor(notificationListFinder); await driver.tap(profileTabFinder);
      await driver.waitUntilNoTransientCallbacks(); await Future.delayed(Duration(seconds:2)); await driver.scrollIntoView(resetmailprofilebuttonFinder);
      await driver.tap(resetmailprofilebuttonFinder); await driver.waitFor(changepasswordtab); await Future.delayed(Duration(seconds:2));
      await driver.tap(returntoprofilebutton); await driver.waitFor(notchangepasswordtab); await Future.delayed(Duration(seconds:2));
      await driver.waitUntilNoTransientCallbacks();await driver.tap(signOutFinder); await Future.delayed(Duration(seconds:2));await driver.waitFor(signoutModal);
      await Future.delayed(Duration(seconds:2));await driver.tap(signoutcancelbutton);await driver.waitForAbsent(signoutModal);await driver.tap(signOutFinder);
      await Future.delayed(Duration(seconds:2));await driver.waitFor(signoutModal);await driver.tap(signoutcontinueButton);await Future.delayed(Duration(seconds:2));
      await driver.waitFor(signInPage);await Future.delayed(Duration(seconds:2)); assert(signInPage != null); await driver.waitUntilNoTransientCallbacks();  
    });

    test('Valid account, Sign in, success, Start procedure,VehicleSearch- not in database', () async {
      await driver.tap(emailFieldTextFinder);await driver.enterText('170454j@tpfs-police.com');await Future.delayed(Duration(seconds:2));      
      await driver.tap(passwordFieldTextFinder);await driver.enterText('12345678');await Future.delayed(Duration(seconds:2));
      await driver.tap(signInbuttonFinder);await Future.delayed(Duration(seconds:2));assert(homePage != null);
      await driver.tap(startprocedurebutton);await Future.delayed(Duration(seconds:2)); await driver.waitFor(procedurePage);assert(procedurePage != null);
      await Future.delayed(Duration(seconds:2));await driver.tap(vehicleProfilesSearchGrid); await driver.waitFor(vehicleSearchPage); assert(vehicleSearchPage != null);
      await Future.delayed(Duration(seconds:2));await driver.tap(searchvehiclebar); await driver.enterText('ki-1234');await Future.delayed(Duration(seconds:5));
      await driver.waitFor(noVehiclePresent);await driver.tap(cancelsearchButton);
      await Future.delayed(Duration(seconds:2));await driver.tap(goBackVehicleButton); await driver.waitFor(procedurePage);
      assert(procedurePage != null);await Future.delayed(Duration(seconds:5));await driver.tap(vehicleProfilesSearchGrid); await driver.waitFor(vehicleSearchPage);
      assert(vehicleSearchPage != null);await Future.delayed(Duration(seconds:2));await driver.tap(goBackVehicleButton); await driver.waitFor(procedurePage);
      assert(procedurePage != null);await driver.scrollIntoView(driverProfileSearchGrid);await driver.tap(driverProfileSearchGrid);
      await driver.waitFor(driverSearchPage);assert(driverSearchPage != null);await Future.delayed(Duration(seconds:2));await driver.tap(searchdriverbar);
      await driver.enterText('52299233bh');await Future.delayed(Duration(seconds:5));await driver.waitFor(noVehiclePresent);await driver.tap(cancelsearchButton);
      await Future.delayed(Duration(seconds:2));await driver.tap(goBackVehicleButton); await driver.waitFor(procedurePage);
      assert(procedurePage != null);await Future.delayed(Duration(seconds:5));await driver.scrollIntoView(driverProfileSearchGrid);await driver.tap(driverProfileSearchGrid);
      await driver.waitFor(driverSearchPage);assert(driverSearchPage != null);await Future.delayed(Duration(seconds:2));
    },timeout: Timeout(Duration(minutes: 1),),);

    test('Start procedure, vehicle and driver search-Create Ticket , Wrong Parameters, Add some details to ticket', 
              () async {
      await driver.tap(emailFieldTextFinder);await driver.enterText('170454j@tpfs-police.com');await Future.delayed(Duration(seconds:2));      
      await driver.tap(passwordFieldTextFinder);await driver.enterText('12345678');await Future.delayed(Duration(seconds:2));
      await driver.tap(signInbuttonFinder);await Future.delayed(Duration(seconds:2));assert(homePage != null);
      await driver.tap(startprocedurebutton);await Future.delayed(Duration(seconds:2)); await driver.waitFor(procedurePage);assert(procedurePage != null);
      await Future.delayed(Duration(seconds:2));await driver.tap(vehicleProfilesSearchGrid); await driver.waitFor(vehicleSearchPage); assert(vehicleSearchPage != null);
      await Future.delayed(Duration(seconds:2));await driver.tap(searchvehiclebar); await driver.enterText('ki-8407');await Future.delayed(Duration(seconds:5));
      await driver.waitFor(vehicleResultPresent);await driver.waitForAbsent(noVehiclePresent);await driver.tap(vehicleResultPresent);
      await driver.waitFor(vehicleResultPage);assert(vehicleResultPage != null);await driver.tap(viewOffencesButton);
      await driver.waitFor(vehicleOffencePage); assert(vehicleOffencePage != null);await Future.delayed(Duration(seconds:2));
      await driver.waitFor(noHistory);await driver.tap(paidticketstab);await driver.waitFor(paidTicketHistory);
      await Future.delayed(Duration(seconds:2));await driver.tap(paidtickettile);await Future.delayed(Duration(seconds:2));
      await driver.tap(goBackVehicleButton);await Future.delayed(Duration(seconds:2));await driver.tap(filterTicketButton);await driver.tap(choiceFilterTextfind);
      await Future.delayed(Duration(seconds:2));await driver.tap(filterResetButton);await Future.delayed(Duration(seconds:2)); await driver.tap(closeFilterButton);
      await driver.tap(goBackVehicleButton);await Future.delayed(Duration(seconds:2));
      await driver.tap(driverAddbutton);await driver.waitFor(driverAdddialog);await driver.tap(driverAddCancelButton);
      await Future.delayed(Duration(seconds:2));await driver.tap(driverAddbutton);await driver.waitFor(driverAdddialog);await driver.tap(driverAddContinueButton);
      await Future.delayed(Duration(seconds:2)); await driver.waitFor(cameraDriverScreen); assert(cameraDriverScreen != null);await Future.delayed(Duration(seconds:2));
      await driver.tap(cameraAddButton);await driver.waitFor(addTicketVehiclePage); assert(addTicketVehiclePage != null);await Future.delayed(Duration(seconds:2));
      await driver.tap(addTicketImageButton);await driver.waitFor(driverTicketAddDialog);await Future.delayed(Duration(seconds:2));await driver.tap(driverTicketCancelButton);
      await Future.delayed(Duration(seconds:2));await driver.tap(goBackVehicleButton); await Future.delayed(Duration(seconds:2));await driver.tap(goBackVehicleButton);
      await driver.waitFor(procedurePage);assert(procedurePage != null);await driver.waitForAbsent(licensePlateTicket);await driver.tap(vehicleProfilesSearchGrid);
      assert(vehicleSearchPage == null);await driver.scrollIntoView(driverProfileSearchGrid);await driver.tap(driverProfileSearchGrid); await driver.waitFor(driverSearchPage);
      assert(driverSearchPage != null); await Future.delayed(Duration(seconds:2));await driver.tap(searchdriverbar);await driver.enterText('53388233bh');
      await Future.delayed(Duration(seconds:5));await driver.waitFor(vehicleResultPresent);await driver.tap(vehicleResultPresent);await Future.delayed(Duration(seconds:2));
      await driver.waitFor(driverResultPage);assert(driverResultPage != null);await Future.delayed(Duration(seconds:2));await driver.scrollIntoView(driverAddbutton);
      await driver.tap(driverAddbutton);await driver.waitFor(driverAdddialog);await driver.tap(driverAddCancelButton);
      await Future.delayed(Duration(seconds:2));await driver.tap(driverAddbutton);await driver.waitFor(driverAdddialog);await driver.tap(driverAddContinueButton);
      await Future.delayed(Duration(seconds:2)); await driver.waitFor(cameraDriverScreen); assert(cameraDriverScreen != null);await Future.delayed(Duration(seconds:2));
      await driver.tap(cameraAddButton);await driver.waitFor(pictureTicketDriverPage); assert(pictureTicketDriverPage != null);await Future.delayed(Duration(seconds:2));
      await driver.tap(addTicketImageButton);await driver.waitFor(driverTicketAddDialog);await Future.delayed(Duration(seconds:2));await driver.tap(driverTicketAddButton);
      await Future.delayed(Duration(seconds:2));await driver.waitFor(procedurePage);assert(procedurePage != null);await driver.waitFor(licenseNumberTicket);
      await driver.tap(driverProfileSearchGrid);assert(driverSearchPage == null);await Future.delayed(Duration(seconds:2));await driver.scrollIntoView(driverProfileSearchGrid);
      await driver.scrollIntoView(criminalAssessmentGrid);await driver.scrollIntoView(createTicketGrid);await driver.tap(createTicketGrid);
      await Future.delayed(Duration(seconds:2));await driver.waitFor(changeNumberButton);await driver.tap(createTicketPageOneButton);
      await driver.waitFor(licenseplateEmptyText);await driver.tap(liceneplateField);await driver.enterText('ki-8407');await Future.delayed(Duration(seconds:2));await driver.tap(changeNumberButton);
      await driver.waitFor(phoneNumberTicketField);await driver.tap(phoneNumberTicketField);await driver.enterText('0771234567');await Future.delayed(Duration(seconds:2));
      await driver.tap(createTicketPageOneButton);await driver.waitFor(createTicketPageTwo); assert(createTicketPageTwo != null);
    },timeout: Timeout(Duration(minutes: 2),),);

    test('Valid account, Sign in, success, Start procedure,CA Assessment', () async {
      await driver.tap(emailFieldTextFinder);await driver.enterText('170454j@tpfs-police.com');await Future.delayed(Duration(seconds:2));      
      await driver.tap(passwordFieldTextFinder);await driver.enterText('12345678');await Future.delayed(Duration(seconds:2));
      await driver.tap(signInbuttonFinder);await Future.delayed(Duration(seconds:2));assert(homePage != null);
      await driver.tap(startprocedurebutton);await Future.delayed(Duration(seconds:2)); await driver.waitFor(procedurePage);assert(procedurePage != null);
      await Future.delayed(Duration(seconds:2));await driver.scrollIntoView(driverProfileSearchGrid);await driver.scrollIntoView(criminalAssessmentGrid);
      await driver.tap(criminalAssessmentGrid);await Future.delayed(Duration(seconds:2));await driver.waitFor(caPicturePage);assert(caPicturePage != null);await driver.tap(caAssessButton);
      await Future.delayed(Duration(seconds:2));await driver.waitFor(takePicturePage);assert(takePicturePage != null);await driver.tap(cameraAddButton);await Future.delayed(Duration(seconds:2));
      await driver.waitFor(caPicturePage);assert(caPicturePage != null);await driver.tap(caAssessButton);await Future.delayed(Duration(seconds:2));
      // await driver.tap(finishprocedurebutton);await driver.waitFor(homePage);assert(homePage != null);await Future.delayed(Duration(seconds:2));
    },timeout: Timeout(Duration(minutes: 2),),);
  });
}
