import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = firebaseAuth.currentUser;
      if (user != null) {
        await DatabaseService(user.uid).saveUserData(name, email);
        return true;
      }
    } // END TRY
    on FirebaseAuthException catch (error) {
      return error.message;
    } // END TRY - CATCH
  }

  Future loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = firebaseAuth.currentUser;
      if (user != null) {
        return true;
      }
    } // END TRY
    on FirebaseAuthException catch (error) {
      return error.message;
    } // END TRY - CATCH
  }

  Future logout() async {
    try {
      await firebaseAuth.signOut();
      await HelperFunctions.saveUserLoggedInStatusSF(false);
      await HelperFunctions.saveUserNameSF('');
      await HelperFunctions.saveUserEmailSF('');
    } catch (error) {
      return null;
    }
  }
}
