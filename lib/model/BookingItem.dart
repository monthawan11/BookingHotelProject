class BookingItem {
  int? keyID;
  final String hotelName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double price;
  final String paymentMethod;
  final String roomType;

  BookingItem({
    this.keyID,
    required this.hotelName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.price,
    this.paymentMethod = "Cash", // ค่าเริ่มต้นเป็น "Cash"
    this.roomType = "Single Room", required String bookingName, required String phoneNumber, // ค่าเริ่มต้นเป็น "Single Room"
  });

  // ฟังก์ชัน copyWith สำหรับการสร้างสำเนาของข้อมูลที่เปลี่ยนแปลง
  BookingItem copyWith({String? paymentMethod}) {
    return BookingItem(
      keyID: keyID,
      hotelName: hotelName,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      price: price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      roomType: roomType, bookingName: '', phoneNumber: '',
    );
  }
}
