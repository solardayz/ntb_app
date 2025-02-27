import 'package:flutter/material.dart';
import 'screens/membership_screen.dart';
import 'screens/login_screen.dart'; // 로그인 화면을 위한 파일

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 예제: 로그인 여부를 확인 (실제 앱에서는 인증 로직으로 대체)
  bool isLoggedIn = false; // 로그인 상태: true이면 MembershipScreen, false이면 LoginScreen
  runApp(MembershipApp(isLoggedIn: isLoggedIn));
}

class MembershipApp extends StatelessWidget {
  final bool isLoggedIn;
  const MembershipApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
      ),
      // 로그인 상태에 따라 다른 초기 화면을 보여줍니다.
      home: isLoggedIn ? const MembershipScreen() : const LoginScreen(),
    );
  }
}
