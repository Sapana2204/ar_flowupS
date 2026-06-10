import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';

class LoginEncryption {
  static Future<String> encryptPassword(String password) async {

    final response = await http.get(
      Uri.parse("https://your-domain.com/salt"),
    );

    final data = jsonDecode(response.body);

    if (data["success"] != true) {
      throw Exception("Unable to fetch encryption key");
    }

    final publicKeyBase64 = data["salt"];

    final publicKey = parsePublicKeyFromBase64(publicKeyBase64);

    final encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.OAEP,
      ),
    );

    return encrypter.encrypt(password).base64;
  }

  static RSAPublicKey parsePublicKeyFromBase64(String key) {
    throw UnimplementedError(
      "Need actual /salt response to implement correctly",
    );
  }
}