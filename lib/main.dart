import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/employee_provider.dart';
import 'responsive/mobile_screen.dart';
import 'responsive/responsive_screen.dart';
import 'responsive/web_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      
      providers: [
       
         ChangeNotifierProvider(
                  create: (context) => EmployeeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vritti App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ResponsiveScreen(
          mobileScreenLayout: MobileScreen(),
          webScreenLayout: WebScreen(),
        ),
      ),
    );
  }
}
