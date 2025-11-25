// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/component/custom_button.dart';
import 'package:chat_app/cubits/authc_cubit/authc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import '../component/constants.dart';
import '../component/custom_textfromfild.dart';
import '../helper/show_snak_bar.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var passwordController = TextEditingController();

  var emailController = TextEditingController();

  GlobalKey<FormState>formkey = GlobalKey();

  bool iscall = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthcCubit, AuthcState>(
      listener: (context, state) {
        if(state is RegisterLoading){
          iscall=true;
        }
        else if(state is RegisterSuccess){
          Navigator.pushReplacementNamed(
              context, 'ChatPage',
              arguments: emailController.text);
          iscall=false;
        }

        else if(state is RegisterFailure){
          iscall=false;
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
                        Center(child: Image.asset('assets/images/scholar.png')),
                        const Center(
                          child: Text(
                            'Scholar Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pacifico',
                              fontSize: 32,
                            ),),
                        ),
                        const Text(
                          ' Register ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),),
                        const SizedBox(height: 20,),
                        CustomTextFormFiled(
                          label: 'Email',
                          controller: emailController,
                          validate: (data) {
                            if (data.isEmpty) {
                              return 'Email Must not be empty';
                            }
                          },
                        ),
                        const SizedBox(height: 10,),
                        CustomTextFormFiled(
                          label: 'Password',
                          controller: passwordController,
                          validate: (data) {
                            if (data.isEmpty) {
                              return 'password Must not be empty';
                            }
                          },
                        ),
                        const SizedBox(height: 10,),
                        CustomButton(
                            label: 'Register',

                            ontap: () async {
                              if (formkey.currentState!.validate()) {
                                await BlocProvider.of<AuthcCubit>(context).createUser(
                                    email: emailController.text,
                                    password: passwordController.text)
                                ;
                              }}
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context,),
                              child: const Text('Sing In',
                                style: TextStyle(
                                    color: Colors.greenAccent, fontSize: 18),
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
    );
  }
}
