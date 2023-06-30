import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_innov/pages/pages.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'services/employee_bloc_service.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        useMaterial3: true,
          
      ),
      home: BlocProvider(
      create: (context) => EmployeeBloc(), child: EmployeeListPage( ),
      )
      
    );
  }
}
