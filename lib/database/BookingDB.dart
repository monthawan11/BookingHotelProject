import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:account/model/BookingItem.dart';

class BookingDB {
  final String dbName;
  static Database? _database;

  BookingDB({required this.dbName});

  // การเชื่อมต่อกับฐานข้อมูล SQLite
  Future<Database> get database async {
    if (_database != null) return _database!;
    String path = join(await getDatabasesPath(), dbName);
    return _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      // สร้างตาราง
      return db.execute(
        "CREATE TABLE bookings(keyID INTEGER PRIMARY KEY, hotelName TEXT, checkInDate TEXT, checkOutDate TEXT, price REAL, paymentMethod TEXT, roomType TEXT)",
      );
    });
  }

  // แปลง BookingItem เป็น Map สำหรับการบันทึกในฐานข้อมูล
  Map<String, dynamic> toMap(BookingItem booking) {
    return {
      'hotelName': booking.hotelName,
      'checkInDate': booking.checkInDate.toIso8601String(),
      'checkOutDate': booking.checkOutDate.toIso8601String(),
      'price': booking.price,
      'paymentMethod': booking.paymentMethod,
      'roomType': booking.roomType,
    };
  }

  // แปลงจาก Map เป็น BookingItem
  BookingItem fromMap(Map<String, dynamic> map) {
    return BookingItem(
      keyID: map['keyID'],
      hotelName: map['hotelName'],
      checkInDate: DateTime.parse(map['checkInDate']),
      checkOutDate: DateTime.parse(map['checkOutDate']),
      price: map['price'],
      paymentMethod: map['paymentMethod'],
      roomType: map['roomType'], bookingName: '', phoneNumber: '',
    );
  }

  // โหลดข้อมูลการจองทั้งหมดจากฐานข้อมูล
  Future<List<BookingItem>> loadAllData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookings');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  // เพิ่มข้อมูลการจองใหม่
  Future<void> insertDatabase(BookingItem booking) async {
    final db = await database;
    await db.insert(
      'bookings',
      toMap(booking),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ลบข้อมูลการจอง
  Future<void> deleteData(BookingItem booking) async {
    final db = await database;
    await db.delete(
      'bookings',
      where: "keyID = ?",
      whereArgs: [booking.keyID],
    );
  }

  // อัปเดตข้อมูลการจอง
  Future<void> updateData(BookingItem booking) async {
    final db = await database;
    await db.update(
      'bookings',
      toMap(booking),
      where: "keyID = ?",
      whereArgs: [booking.keyID],
    );
  }
}
