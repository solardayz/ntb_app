import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerService {
  // 서버 URL은 실제 서버 엔드포인트에 맞게 수정하세요.
  static final Uri _url = Uri.parse("https://example.com/api/qr-scan");

  static Future<String> sendQRData(String qrData) async {
    try {
      final response = await http.post(
        _url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrData': qrData}),
      );
      if (response.statusCode == 200) {
        return "성공: ${response.body}";
      } else {
        return "오류: ${response.statusCode}";
      }
    } catch (e) {
      return "네트워크 오류: $e";
    }
  }
}
