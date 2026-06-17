import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

class LoginEncryption {
  static const String saltUrl =
      "https://api.calldesk.flowups.in/api/v1/salt";

  /// Fetch Public Key
  static Future<String> getPublicKey() async {
    try {
      print("🔑 Hitting Salt API...");
      print("🌐 URL: https://api.calldesk.flowups.in/api/v1/salt");

      final response = await http.get(
        Uri.parse("https://api.calldesk.flowups.in/api/v1/salt"),
      );

      print("📥 Salt Status Code: ${response.statusCode}");
      print("📥 Salt Response: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
          "Salt API failed with status ${response.statusCode}",
        );
      }

      final data = jsonDecode(response.body);

      print("🔑 Public Key Received");
      print("🔑 Key Length: ${data['salt']?.length}");

      return data["salt"];
    } catch (e, stackTrace) {
      print("❌ Salt API Error: $e");
      print(stackTrace);
      rethrow;
    }
  }

  /// Encrypt Password
  static Future<String> encryptPassword(
      String password,
      ) async {
    final publicKeyString = await getPublicKey();

    final publicKey = parsePublicKey(publicKeyString);

    final oaep = OAEPEncoding.withSHA256(
      RSAEngine(),
    );

    oaep.init(
      true,
      PublicKeyParameter<RSAPublicKey>(
        publicKey,
      ),
    );

    final encryptedBytes = _processInBlocks(
      oaep,
      Uint8List.fromList(
        utf8.encode(password),
      ),
    );

    final encryptedBase64 =
    base64Encode(encryptedBytes);

    print("✅ Password encrypted");
    print("🔒 Length: ${encryptedBase64.length}");

    return encryptedBase64;
  }

  static RSAPublicKey parsePublicKey(String base64Key) {
    final keyBytes = base64Decode(base64Key);

    final parser = ASN1Parser(keyBytes);
    final topLevelSeq = parser.nextObject() as ASN1Sequence;

    final publicKeyBitString =
    topLevelSeq.elements![1] as ASN1BitString;

    final publicKeyBytes = Uint8List.fromList(
      List<int>.from(publicKeyBitString.contentBytes()),
    );

    final publicKeyParser = ASN1Parser(publicKeyBytes);
    final publicKeySeq =
    publicKeyParser.nextObject() as ASN1Sequence;

    final modulus =
    publicKeySeq.elements![0] as ASN1Integer;

    final exponent =
    publicKeySeq.elements![1] as ASN1Integer;

    return RSAPublicKey(
      modulus.valueAsBigInteger!,
      exponent.valueAsBigInteger!,
    );
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine,
      Uint8List input,
      ) {
    final output = <int>[];

    var offset = 0;

    while (offset < input.length) {
      final chunkSize =
      (input.length - offset > engine.inputBlockSize)
          ? engine.inputBlockSize
          : input.length - offset;

      final chunk = engine.process(
        input.sublist(offset, offset + chunkSize),
      );

      output.addAll(chunk);

      offset += chunkSize;
    }

    return Uint8List.fromList(output);
  }
}