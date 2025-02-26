import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/membership_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MembershipApp());
}

class MembershipApp extends StatelessWidget {
  const MembershipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MembershipScreen(),
    );
  }
}
