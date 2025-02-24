import 'dart:io';
import 'package:flutter/material.dart';
import 'package:account/model/BookingItem.dart';
import 'package:account/main.dart';

// ignore: must_be_immutable
class BookingConfirmationScreen extends StatefulWidget {
  final BookingItem item;
  String bookingName;
  String phoneNumber;
  final File? proofOfPayment;

  BookingConfirmationScreen({
    super.key,
    required this.item,
    required this.bookingName,
    required this.phoneNumber,
    this.proofOfPayment,
  });

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  late TextEditingController bookingNameController;
  late TextEditingController phoneNumberController;
  bool isEditing = false; // ✅ โหมดแก้ไข

  @override
  void initState() {
    super.initState();
    bookingNameController = TextEditingController(text: widget.bookingName);
    phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  void _saveChanges() {
    setState(() {
      // ✅ อัปเดตค่าของตัวแปรให้เป็นค่าที่แก้ไข
      widget.bookingName = bookingNameController.text;
      widget.phoneNumber = phoneNumberController.text;
      isEditing = false; // กลับสู่โหมดแสดงผล
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ อัปเดตข้อมูลสำเร็จ!")),
    );
  }

  void _deleteBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑️ ยกเลิกการจองสำเร็จ!")),
    );

    // ✅ กลับไปหน้าหลัก
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade700,
        title: const Text(
          '🔖 ใบยืนยันการจอง',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "✅ การจองเสร็จสมบูรณ์!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ ข้อมูลผู้จอง
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                color: Colors.brown.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (isEditing) ...[
                        TextField(
                          controller: bookingNameController,
                          decoration: const InputDecoration(
                              labelText: "👤 ชื่อผู้จอง"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              labelText: "📞 เบอร์โทรศัพท์"),
                          keyboardType: TextInputType.phone,
                        ),
                      ] else ...[
                        ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.brown),
                          title: Text(" ชื่อผู้จอง: ${widget.bookingName}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.phone, color: Colors.brown),
                          title: Text(" เบอร์โทรศัพท์: ${widget.phoneNumber}",
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ รายละเอียดการจอง
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🏨 โรงแรม: ${widget.item.hotelName}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Text(
                          "📅 วันเช็คอิน: ${widget.item.checkInDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(
                          "📅 วันเช็คเอาท์: ${widget.item.checkOutDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("🛏 ประเภทห้อง: ${widget.item.roomType}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("💰 ราคาที่พัก: ${widget.item.price} บาท",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ ปุ่ม แก้ไข / บันทึก
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.green : Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  
                  label: Text(isEditing ? "✅ บันทึก" : "✏️ แก้ไขข้อมูล"),
                  onPressed: () {
                    if (isEditing) {
                      _saveChanges();
                    } else {
                      setState(() {
                        isEditing = true; // ✅ เข้าสู่โหมดแก้ไข
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ✅ ปุ่ม ลบการจอง
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  
                  label: const Text("🗑️ ยกเลิกการจอง"),
                  onPressed: _deleteBooking,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
