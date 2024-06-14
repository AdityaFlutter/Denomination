import 'package:denomination/utils/SqliteDataBase.dart';
import 'package:denomination/views/homeScreen/homeScreen.dart';
import 'package:denomination/views/homeScreen/homeScreenCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var navigatorKey = GlobalKey<NavigatorState>();
SqliteDataBase sqliteDatabase = SqliteDataBase();


void main() {
  WidgetsFlutterBinding.ensureInitialized();
   sqliteDatabase.getDataBase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  ));
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeScreenCubit>(
        create: (context) => HomeScreenCubit(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Denomination",
      navigatorKey: navigatorKey,
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    ),
  ));
}
