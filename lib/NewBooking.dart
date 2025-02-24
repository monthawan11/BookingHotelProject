import 'package:account/model/BookingItem.dart';
import 'package:account/provider/BookingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // สำหรับ FilteringTextInputFormatter
import 'BookingSummaryScreen.dart';

class Newbooking extends StatefulWidget {
  BookingItem item;

  Newbooking({super.key, required this.item});

  @override
  State<Newbooking> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<Newbooking> {
  final formKey = GlobalKey<FormState>();
  final hotelNameController = TextEditingController();
  final priceController = TextEditingController();
  final bookingNameController = TextEditingController(); // ช่องกรอกชื่อผู้จอง
  final phoneNumberController =
      TextEditingController(); // ช่องกรอกเบอร์โทรศัพท์

  int adults = 1;
  int children = 0;
  int infants = 0;
  String roomType = 'Single Room';
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Map<String, double> roomPrices = {
    'Single Room': 1000.0,
    'Standard Double Room': 1500.0,
    'Twin Room': 1800.0,
    'Deluxe Double Room': 2200.0,
    'Studio/Apartment': 3000.0,
    'Junior Suite': 4000.0,
    'Executive Suite': 5000.0,
    'Presidential Suite': 7000.0,
  };

  @override
  void initState() {
    super.initState();
    hotelNameController.text = widget.item.hotelName;
    priceController.text = widget.item.price.toString();
    checkInDate = widget.item.checkInDate;
    checkOutDate = widget.item.checkOutDate;
    roomType = widget.item.roomType ?? 'Single Room';
  }

  @override
  void dispose() {
    hotelNameController.dispose();
    priceController.dispose();
    bookingNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    if (checkInDate != null && checkOutDate != null) {
      int days = checkOutDate!.difference(checkInDate!).inDays;
      double totalPrice = days * (roomPrices[roomType] ?? 0);
      priceController.text = totalPrice.toStringAsFixed(2);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? checkInDate ?? DateTime.now()
          : checkOutDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
        _calculateTotalPrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('เพิ่มข้อมูลการจองใหม่'),
        foregroundColor: Colors.white, // ตั้งสีตัวอักษรให้เป็นสีขาว
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ฟอร์มกรอกชื่อโรงแรม
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อโรงแรม',
                    labelStyle: TextStyle(
                        color: Colors.black, fontSize: 20), // เพิ่มขนาดตัวอักษร
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: hotelNameController,
                  readOnly: true,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold), // เพิ่มขนาดและทำให้ตัวหนา
                ),
                const SizedBox(height: 10),

                // เลือกประเภทห้องพักและแสดงราคา
                DropdownButtonFormField<String>(
                  value: roomPrices.keys.contains(roomType)
                      ? roomType
                      : roomPrices.keys.first,
                  decoration: const InputDecoration(
                    labelText: 'ประเภทห้องพัก',
                    border: OutlineInputBorder(),
                  ),
                  items: roomPrices.keys
                      .toSet()
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      roomType = value!;
                      _calculateTotalPrice(); // คำนวณราคาใหม่หลังจากเลือกห้อง
                    });
                  },
                ),
                const SizedBox(height: 10),

                // ปฏิทินเลือกวันที่เช็คอินและเช็คเอาท์
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => _selectDate(context, true),
                        child: Text(
                          checkInDate != null
                              ? "Check-in: ${checkInDate!.toLocal()}"
                                  .split(' ')[0]
                              : "เลือกวัน Check-in",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => _selectDate(context, false),
                        child: Text(
                          checkOutDate != null
                              ? "Check-out: ${checkOutDate!.toLocal()}"
                                  .split(' ')[0]
                              : "เลือกวัน Check-out",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ช่องกรอกจำนวนผู้เข้าพัก
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: adults,
                        decoration: const InputDecoration(labelText: 'ผู้ใหญ่'),
                        items: List.generate(10, (index) => index + 1)
                            .map((num) => DropdownMenuItem(
                                value: num, child: Text('$num')))
                            .toList(),
                        onChanged: (value) => setState(() => adults = value!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: children,
                        decoration: const InputDecoration(labelText: 'เด็ก'),
                        items: List.generate(6, (index) => index)
                            .map((num) => DropdownMenuItem(
                                value: num, child: Text('$num')))
                            .toList(),
                        onChanged: (value) => setState(() => children = value!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: infants,
                        decoration: const InputDecoration(labelText: 'ทารก'),
                        items: List.generate(3, (index) => index)
                            .map((num) => DropdownMenuItem(
                                value: num, child: Text('$num')))
                            .toList(),
                        onChanged: (value) => setState(() => infants = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ช่องกรอกราคารวม
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'ราคารวม'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),

                // ช่องกรอกชื่อผู้จอง
                TextFormField(
                  controller: bookingNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อผู้จอง',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อผู้จอง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // ช่องกรอกเบอร์โทรศัพท์ (กรอกได้เฉพาะตัวเลข)
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number, // ทำให้รับเฉพาะตัวเลข
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // ป้องกันการกรอกตัวอักษร
                  ],
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทรศัพท์',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเบอร์โทรศัพท์';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ปุ่มยืนยันการจอง (ให้อยู่ตรงกลาง)
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    // icon: const Icon(Icons.check),
                    label: const Text('ยืนยันการจอง',
                        style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (checkInDate == null || checkOutDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    '⚠️ กรุณาเลือกวัน Check-in และ Check-out')),
                          );
                          return;
                        }

                        BookingItem item = BookingItem(
                          keyID: widget.item.keyID,
                          hotelName: hotelNameController.text,
                          checkInDate: checkInDate!,
                          checkOutDate: checkOutDate!,
                          price: double.parse(priceController.text),
                          roomType: roomType,
                          paymentMethod: '',
                          bookingName: bookingNameController.text,
                          phoneNumber: phoneNumberController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingSummaryScreen(
                              item: item,
                              bookingName: bookingNameController.text,
                              phoneNumber: phoneNumberController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
