import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QRCodeHistory {
  final String qrData;
  final DateTime scannedAt;

  QRCodeHistory({required this.qrData, required this.scannedAt});

  Map<String, dynamic> toMap() {
    return {
      'qrData': qrData,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory QRCodeHistory.fromMap(Map<String, dynamic> map) {
    return QRCodeHistory(
      qrData: map['qrData'],
      scannedAt: DateTime.parse(map['scannedAt']),
    );
  }

  // Add a method to encode and decode URLs
  static String encodeUrl(String url) {
    return Uri.encodeFull(url);
  }

  static String decodeUrl(String encodedUrl) {
    return Uri.decodeFull(encodedUrl);
  }
}

class DatabaseHelper {
  static late Database _database;

  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'qr_code_history.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE qr_code_history(qrData TEXT, scannedAt TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> deleteQRCodeHistory(QRCodeHistory qrCodeHistory) async {
    final db = await _database;
    await db.delete(
      'qr_code_history',
      where: 'qrData = ? AND scannedAt = ?',
      whereArgs: [
        qrCodeHistory.qrData,
        qrCodeHistory.scannedAt.toIso8601String()
      ],
    );
  }

  static Future<void> insertQRCodeHistory(QRCodeHistory qrCodeHistory) async {
    await _database.insert(
      'qr_code_history',
      qrCodeHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<QRCodeHistory>> getQRCodeHistory() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('qr_code_history');
    return List.generate(maps.length, (i) {
      return QRCodeHistory(
        qrData: QRCodeHistory.decodeUrl(maps[i]['qrData']),
        scannedAt: DateTime.parse(maps[i]['scannedAt']),
      );
    });
  }
}
