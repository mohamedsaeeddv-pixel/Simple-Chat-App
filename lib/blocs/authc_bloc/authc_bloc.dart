import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'authc_event.dart';
part 'authc_state.dart';

class AuthcBloc extends Bloc<AuthcEvent, AuthcState> {
  AuthcBloc() : super(AuthcInitial()) {
    
    // ===== Password show/hide =====
    on<ShowOrHiddenPasswordEvent>((event, emit) {
      emit(LoginShowPassword());
    });

    // ===== Email/Password Login =====
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess(provider: "email"));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginFailure(errorMessage: 'User not found'));
        } else if (e.code == 'wrong-password') {
          emit(LoginFailure(errorMessage: 'Wrong password'));
        } else {
          emit(LoginFailure(errorMessage: e.message ?? 'Something went wrong'));
        }
      } catch (e) {
        emit(LoginFailure(errorMessage: 'Something went wrong'));
      }
    });

    // ===== Google Sign-In =====
    on<LoginWithGoogleEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();  

        if (googleUser == null) {
          emit(LoginFailure(errorMessage: "User canceled sign in"));
          return;
        }

        final googleAuth = await googleUser.authentication;
        final googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
        emit(LoginSuccess(provider: "google"));

      } catch (e) {
        emit(LoginFailure(errorMessage: e.toString()));
      }
    });
  }
}
