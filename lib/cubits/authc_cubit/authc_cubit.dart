import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'authc_state.dart';

class AuthcCubit extends Cubit<AuthcState> {
  AuthcCubit() : super(AuthcInitial());
  bool showPassword=true;
  void showOrHiddenPassword(){
    try {
      showPassword = !showPassword;
      emit(LoginShowPassword());
    }catch(ex){
      print(ex);
    }
  }
  Future<void> loginUser({
    required String email,
    required String password}) async
  {
    emit(LoginLoading());
    try{
      UserCredential user =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMessage: 'wrong - Password'));
      }
    }
    catch(e){
      emit(LoginFailure(errorMessage: 'Something Went Wrong'));    }
  }

  Future<void> createUser({
    required String email,
    required String password}) async
  {
    emit(RegisterLoading());
    try{
      UserCredential user =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errorMessage: 'weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMessage: 'email-already-in-use'));
      }
    }
    catch(e){
      emit(RegisterFailure(errorMessage: 'Something Went Wrong'));    }
  }
}
