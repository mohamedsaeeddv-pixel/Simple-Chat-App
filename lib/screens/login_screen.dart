// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import '../blocs/authc_bloc/authc_bloc.dart';
import '../cubits/chat_cubit/chat_cubit.dart';
import '../component/constants.dart';
import '../component/custom_button.dart';
import '../component/custom_textfromfild.dart';
import '../helper/show_snak_bar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool iscall = false;
  bool showPassword = true;
  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthcBloc>(
      create: (_) => AuthcBloc(),
      child: BlocConsumer<AuthcBloc, AuthcState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            iscall = true;
          } else if (state is LoginShowPassword) {
            showPassword = !showPassword;
          } else if (state is LoginSuccess) {
            iscall = false;
            BlocProvider.of<ChatCubit>(context).getMessage();
            Navigator.pushReplacementNamed(
              context,
              'ChatPage',
              arguments: state.provider,
            );
          } else if (state is LoginFailure) {
            iscall = false;
            buildSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: iscall,
            child: Scaffold(
              backgroundColor: primaryColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Image.asset(primaryImage)),
                          const Center(
                            child: Text(
                              'Scholar Chat',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Pacifico',
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const Text(
                            ' Login ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormFiled(
                            label: 'Email',
                            controller: emailController,
                            validate: (data) {
                              if (data.isEmpty) {
                                return 'Email must not be empty';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormFiled(
                            label: 'Password',
                            showPassword: showPassword,
                            controller: passwordController,
                            suffixIcon: IconButton(
                              onPressed: () {
                                context.read<AuthcBloc>().add(ShowOrHiddenPasswordEvent());
                              },
                              icon: Icon(
                                showPassword ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            validate: (data) {
                              if (data.isEmpty) {
                                return 'Password must not be empty';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            label: 'Login',
                            ontap: () {
                              if (formkey.currentState!.validate()) {
                                context.read<AuthcBloc>().add(LoginEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            label: 'Sign in with Google',
                            ontap: () {
                              context.read<AuthcBloc>().add(LoginWithGoogleEvent());
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, 'Register'),
                                child: const Text(
                                  'Register Now!',
                                  style: TextStyle(color: Colors.greenAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
