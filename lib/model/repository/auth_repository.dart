import 'package:auto_id/shared/widgets/toast_helper.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../module/users/app_admin.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final GoogleSignIn _googleSignIn;
  AppAdmin currUser = AppAdmin.empty;

  AuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        sendConfirmationMail(user);
        currUser = AppAdmin.fromFirebaseUser(user);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FireBaseAuthErrors.fromCode(e.code);
    } catch (_) {
      throw const FireBaseAuthErrors();
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      User? user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        if (user.emailVerified) {
          currUser = AppAdmin.fromFirebaseUser(user);
        } else {
          sendConfirmationMail(user);
          throw const FireBaseAuthErrors("Email not verified");
        }
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FireBaseAuthErrors.fromCode(e.code);
    } catch (_) {
      throw const FireBaseAuthErrors();
    }
  }

  Future<void> sendConfirmationMail(User user) async {
    await user.sendEmailVerification().whenComplete(() {
      showToast("Verification email sent to our email please check it",
          type: ToastType.info);
    });
  }

  Future<void> signInUsingGoogle() async {
    try {
      final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        currUser = AppAdmin.fromFirebaseUser(user);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FireBaseAuthErrors.fromCode(e.code);
    } catch (e) {
      throw const FireBaseAuthErrors();
    }
  }

  Future<void> signOut() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> forgetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FireBaseAuthErrors.fromCode(e.code);
    } catch (_) {
      throw const FireBaseAuthErrors();
    }
  }
}

class FireBaseAuthErrors implements Exception {
  const FireBaseAuthErrors([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FireBaseAuthErrors.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FireBaseAuthErrors(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const FireBaseAuthErrors(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const FireBaseAuthErrors(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const FireBaseAuthErrors(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const FireBaseAuthErrors(
          'Please enter a stronger password.',
        );
      case 'user-not-found':
        return const FireBaseAuthErrors(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const FireBaseAuthErrors(
          'Incorrect password, please try again.',
        );
      case 'account-exists-with-different-credential':
        return const FireBaseAuthErrors(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const FireBaseAuthErrors(
          'The credential received is malformed or has expired.',
        );
      case 'invalid-verification-code':
        return const FireBaseAuthErrors(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const FireBaseAuthErrors(
          'The credential verification ID received is invalid.',
        );
      default:
        return const FireBaseAuthErrors();
    }
  }
  final String message;
}
