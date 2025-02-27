import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../widgets/stat_circle.dart';
import '../widgets/monthly_chart.dart';
import 'qr_scanner_screen.dart';
import 'user_screen.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final double overallAttendance = 0.75;
  final double weeklyAttendance = 0.60;
  final double monthlyAttendance = 0.80;
  final List<double> monthlyAttendanceData = [
    0.8, 0.75, 0.9, 0.6, 0.85, 0.7, 0.8, 0.95, 0.65, 0.9, 0.8, 0.77,
  ];
  final List<String> monthLabels = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
  ];

  DateTime _selectedDate = DateTime.now();
  List<double> _animationHeights = [];

  @override
  void initState() {
    super.initState();
    _animationHeights = List.filled(monthlyAttendanceData.length, 0.0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        for (int i = 0; i < monthlyAttendanceData.length; i++) {
          _animationHeights[i] = monthlyAttendanceData[i] * 150;
        }
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.grey[850]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[800],
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);

  // QR 스캔 후 서버에 데이터를 전송하는 함수
  Future<void> _sendQRDataToServer(String qrData) async {
    final url = Uri.parse("https://example.com/api/qr-scan");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrData': qrData}),
      );
      if (response.statusCode == 200) {
        // 성공 응답 처리
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("서버 응답"),
            content: Text("성공: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
        );
      } else {
        // 에러 응답 처리
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("서버 응답"),
            content: Text("오류: ${response.statusCode}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // 네트워크 에러 처리
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("오류"),
          content: Text("네트워크 오류: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProfileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            'https://pimg.mk.co.kr/meet/neds/2014/10/image_readtop_2014_1274942_14123176891560616.jpg',
          ),
        ),
        SizedBox(width: 10),
        Text(
          '신종훈',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          formattedDate,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatCircle(
          label: "전체",
          percent: overallAttendance,
          progressColor: Colors.white,
        ),
        StatCircle(
          label: "월간",
          percent: weeklyAttendance,
          progressColor: Colors.white,
        ),
        StatCircle(
          label: "주간",
          percent: monthlyAttendance,
          progressColor: Colors.grey[100]!,
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MonthlyChart(
        monthLabels: monthLabels,
        animationHeights: _animationHeights,
      ),
    );
  }

  Widget _buildAttendanceCheckButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
        ),
        onPressed: () async {
          // QR 스캔 화면으로 이동 후 스캔 결과 받기
          final scannedData = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          );
          if (scannedData != null) {
            // 스캔 결과를 서버로 전송하는 로직 실행
            await _sendQRDataToServer(scannedData.toString());
          }
        },
        child: const Text('출석 체크', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
        },
        child: const Text('마이엔티비', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black26, Colors.grey[600]!],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(12),
      child: const Text(
        'NTB © 2025',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NTB 통합멤버십',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: _buildFooter(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[700]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildDateSelector(),
              const SizedBox(height: 20),
              _buildStatCircles(),
              const SizedBox(height: 12),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildMonthlyChart(),
              const SizedBox(height: 8),
              const Text(
                "월별 출석률",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildAttendanceCheckButton(),
              const SizedBox(height: 16),
              _buildButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
