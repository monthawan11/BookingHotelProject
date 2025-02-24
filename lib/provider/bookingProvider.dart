import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:account/model/BookingItem.dart';
import 'package:account/database/BookingDB.dart';

class BookingProvider with ChangeNotifier {
  final BookingDB _db = BookingDB(dbName: 'bookings.db'); // ตั้งชื่อฐานข้อมูลให้ถูกต้อง
  List<BookingItem> _bookings = [];
  bool _isLoading = false;

  UnmodifiableListView<BookingItem> get bookings => UnmodifiableListView(_bookings);

  bool get isLoading => _isLoading;

  // โหลดข้อมูลจากฐานข้อมูล
  Future<void> initData() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _db.loadAllData();
    } catch (e) {
      debugPrint("❌ เกิดข้อผิดพลาดขณะโหลดข้อมูลการจอง: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // เพิ่มข้อมูลการจอง
  Future<void> addBooking(BookingItem booking) async {
    try {
      await _db.insertDatabase(booking);
      await initData(); // โหลดข้อมูลใหม่
    } catch (e) {
      debugPrint("❌ ไม่สามารถเพิ่มข้อมูลการจองได้: $e");
    }
  }

  // ลบข้อมูลการจอง
  Future<void> deleteBooking(BookingItem booking) async {
    try {
      await _db.deleteData(booking);
      await initData(); // โหลดข้อมูลใหม่
    } catch (e) {
      debugPrint("❌ ไม่สามารถลบข้อมูลการจองได้: $e");
    }
  }

  // อัปเดตข้อมูลการจอง
  Future<void> updateBooking(BookingItem booking) async {
    try {
      await _db.updateData(booking);
      await initData(); // โหลดข้อมูลใหม่
    } catch (e) {
      debugPrint("❌ ไม่สามารถอัปเดตข้อมูลการจองได้: $e");
    }
  }

  // ค้นหาการจองตาม keyID
  BookingItem? getBookingById(int id) {
    try {
      return _bookings.firstWhere((booking) => booking.keyID == id, orElse: () => null!);
    } catch (e) {
      debugPrint("❌ ไม่พบข้อมูลการจองที่มี ID: $id, Error: $e");
      return null;
    }
  }
}
