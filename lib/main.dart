import 'package:demo_app/models/training_part.dart';
import 'package:demo_app/providers/training_item_model.dart';
import 'package:demo_app/providers/training_part_model.dart';
import 'package:demo_app/providers/training_record_model.dart';
import 'package:demo_app/providers/training_type_model.dart';
import 'package:demo_app/screens/edit_training_screen.dart';
import 'package:demo_app/screens/stats_screen_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/screens/home_screen.dart';
import 'package:demo_app/screens/record_screen.dart';
import 'package:demo_app/screens/add_training_screen.dart';
import 'package:demo_app/screens/select_training_screen.dart';
import 'package:demo_app/providers/training_record_model.dart';
import 'providers/settings_provider.dart';
import 'package:demo_app/screens/edit_profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TrainingRecordModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrainingItemModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrainingTypeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrainingPartModel(),
        )
      ],
      child: MaterialApp(
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          RecordScreen.id: (context) => RecordScreen(),
          AddTrainingScreen.id: (context) => AddTrainingScreen(),
          SelectTrainingScreen.id: (context) => SelectTrainingScreen(),
          EditProfileScreen.id: (context) => EditProfileScreen(),
          EditTrainingScreen.id: (context) => EditTrainingScreen(),
        },
        theme: ThemeData(
            primaryColor: Colors.deepOrange, accentColor: Colors.redAccent),
      ),
    );
  }
}
