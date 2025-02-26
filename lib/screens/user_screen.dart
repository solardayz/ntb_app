import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사용자 정보"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[700]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://pimg.mk.co.kr/meet/neds/2014/10/image_readtop_2014_1274942_14123176891560616.jpg',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "신종훈",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "user@example.com",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              const Text(
                "010-1234-5678",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                ),
                child: const Text(
                  "뒤로가기",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
