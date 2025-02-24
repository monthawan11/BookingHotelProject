import 'package:account/BookingConfirmationScreen.dart';
import 'package:account/model/BookingItem.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BookingSummaryScreen extends StatefulWidget {
  final BookingItem item;
  final String bookingName; // รับข้อมูลชื่อผู้จอง
  final String phoneNumber; // รับข้อมูลเบอร์โทรศัพท์

  const BookingSummaryScreen({
    super.key,
    required this.item,
    required this.bookingName, // รับชื่อผู้จอง
    required this.phoneNumber, // รับเบอร์โทรศัพท์
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  String paymentMethod = 'Credit Card';
  final creditCardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  File? proofOfPayment;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        proofOfPayment = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade700,
        title: const Text(
          '📋 สรุปการจอง',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'รายละเอียดผู้เข้าพัก',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ชื่อ: ${widget.bookingName}",
                        style: const TextStyle(fontSize: 18)),
                    Text("เบอร์โทรศัพท์: ${widget.phoneNumber}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              _buildCard(
                title: '🏨 รายละเอียดการจอง',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("โรงแรม: ${widget.item.hotelName}",
                        style: const TextStyle(fontSize: 18)),
                    const Divider(),
                    Text(
                      "📅 เช็คอิน: ${widget.item.checkInDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "📅 เช็คเอาท์: ${widget.item.checkOutDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text("🛏 ประเภทห้อง: ${widget.item.roomType}",
                        style: const TextStyle(fontSize: 16)),
                    Text(
                      "💰 ราคาที่พัก: ${widget.item.price} บาท",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),

              _buildCard(
                title: '💳 ช่องทางการชำระเงิน',
                content: DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: ['Credit Card', 'Bank Transfer', 'Cash']
                      .map((method) =>
                          DropdownMenuItem(value: method, child: Text(method)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                ),
              ),

              // ช่องกรอกข้อมูลบัตรเครดิต
              if (paymentMethod == 'Credit Card')
                _buildCard(
                  title: '💳 ข้อมูลบัตรเครดิต',
                  content: Column(
                    children: [
                      _buildTextField(
                          creditCardNumberController, 'หมายเลขบัตรเครดิต'),
                      _buildTextField(
                          cardHolderNameController, 'ชื่อผู้ถือบัตร'),
                      _buildTextField(
                          expiryDateController, 'วันหมดอายุ (MM/YY)'),
                      _buildTextField(cvvController, 'CVV', isNumeric: true),
                    ],
                  ),
                )

              // ช่องสำหรับโอนเงินแนบหลักฐานการชำระเงิน
              else if (paymentMethod == 'Bank Transfer')
                _buildCard(
                  title: '🏦 รายละเอียดบัญชีธนาคาร',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("💳 ธนาคาร: กรุงเทพ"),
                      const Text("🔢 เลขบัญชี: 123-456-789"),
                      const Text("👤 ชื่อบัญชี: โรงแรม ABC"),
                      const SizedBox(height: 10),
                      proofOfPayment != null
                          ? Image.file(proofOfPayment!, height: 150)
                          : ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('📤 อัปโหลดหลักฐาน'),
                            ),
                    ],
                  ),
                )

              // ข้อความแจ้งเตือนสำหรับเงินสด
              else
                _buildCard(
                  title: '💵 ชำระเงินสด',
                  content: const Text(
                    "กรุณาชำระเงินที่เคาน์เตอร์เช็คอินในวันเข้าพัก",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),

              const SizedBox(height: 20),

              // ปุ่ม "เสร็จสิ้น"
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  label:
                      const Text("เสร็จสิ้น", style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingConfirmationScreen(
                          item: widget.item
                              .copyWith(paymentMethod: paymentMethod),
                          bookingName: widget.bookingName,
                          phoneNumber: widget.phoneNumber,
                          proofOfPayment: proofOfPayment,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: content,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    );
  }
}
