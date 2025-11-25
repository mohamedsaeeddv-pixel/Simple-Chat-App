import 'package:chat_app/cubits/authc_cubit/authc_cubit.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer/simple_bloc_observer.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthcCubit(),) ,
        BlocProvider(create: (context) => ChatCubit(),) ,
        // BlocProvider(create: (context) => AuthcBloc(),) ,

      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'Register': (context) => RegisterScreen(),
          'Login': (context) => LoginScreen(),
          'ChatPage': (context) => ChatScreen(),
        },
        initialRoute: 'Login',
        theme: ThemeData(
        ),
        home: LoginScreen(),
      ),
    );
  }
}

