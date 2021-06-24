import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/snackbar_service.dart';
import '../services/navigation_service.dart';
import '../services/db_service.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  FirebaseUser user;
  FirebaseUser doctor;
  AuthStatus status;
  FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin()async{
    if(user != null){
      await DBService.instance.updateUserLastSeenTime(user.uid);
      return NavigationService.instance.navigateToReplacement("home");
    }
  }

  void _checkCurrentUserIsAuthenticated() async{
    user = await _auth.currentUser();
    if(user != null){
      notifyListeners();
      await _autoLogin();
    }

  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSankBarError("Welcome, ${user.email}");
      await DBService.instance.updateUserLastSeenTime(user.uid);
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSankBarError("Error Authenticating");
      user =null;
    }
    notifyListeners();
  }
  void loginDoctorWithEmailAndPassword(String _email, String _password)async{
    status = AuthStatus.Authenticating;
    notifyListeners();
    try{
      AuthResult _result= await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      doctor = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSankBarSuccess("Welcome, ${doctor.displayName}");
      //Navigate To Homepage
    } catch (e){
      status = AuthStatus.Error;
      SnackBarService.instance.showSankBarError("Error Authenticating");
    }
    notifyListeners();
  }
  void registerUserWithEmailAndPassword(String _email , String _password,
      Future<void> onSuccess(String _uid))async{
        status = AuthStatus.Authenticating;
        notifyListeners();
        try{
          AuthResult _result=await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
          user = _result.user;
          status = AuthStatus.Authenticated;
          SnackBarService.instance.showSankBarError("Welcome, ${user.email}");
          await DBService.instance.updateUserLastSeenTime(user.uid);
          await onSuccess(user.uid);
          NavigationService.instance.goBack();
          NavigationService.instance.navigateToReplacement("home");

        }catch (e){
          status =AuthStatus.Error;
          user=null;
          SnackBarService.instance.showSankBarError("Error Registering User");

        }
        notifyListeners();
  }
  void logoutUser(Future<void> onSuccess()) async {
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement("login");
      SnackBarService.instance.showSankBarSuccess("Logged Out Successfully!");
    } catch (e) {
      SnackBarService.instance.showSankBarError("Error Logging Out");
    }
    notifyListeners();
  }
}