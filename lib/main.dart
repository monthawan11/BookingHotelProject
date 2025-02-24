import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/BookingProvider.dart';
import "package:account/NewBooking.dart";
import 'package:account/model/BookingItem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ระบบจองที่พัก',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
          primaryColor: Colors.brown,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black54),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.brown,
          ),
        ),
        home: const MyHomePage(title: 'โรงแรมที่แนะนำ'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, dynamic>> recommendedHotels = [
    {
      'name': 'โรงแรมสยามพารากอน',
      'review': 'สะดวกสบาย ใกล้แหล่งช็อปปิ้ง',
      'image':
          'https://www.chillpainai.com/src/wewakeup/scoop/images/5a760a09f6d8146ff3f58ebb0a7b73988118875c.jpg'
    },
    {
      'name': 'โรงแรมแกรนด์เซ็นเตอร์พอยท์',
      'review': 'วิวสวย บริการดี',
      'image':
          'https://static51.com-hotel.com/uploads/hotel/69235/photo/grande-centre-point-hotel-ploenchit_15216301451.jpg'
    },
    {
      'name': 'โรงแรมโอเรียนเต็ล',
      'review': 'สุดยอดความหรูหรา',
      'image': 'https://www.outthere.travel/wp-content/uploads/2020/04/Mandarin-Oriental-Bangkok-Thailand_Feat-1536x1024.jpg'
    },
    {
      'name': 'โรงแรมแมริออท',
      'review': 'สระว่ายน้ำสวยมาก',
      'image': 'https://www.matichonweekly.com/wp-content/uploads/2016/12/S__52363278.jpg'
    },
    {
      'name': 'โรงแรมเชอราตัน',
      'review': 'ห้องพักกว้างขวางและสะอาด',
      'image': 'https://teawlataem.com/wp-content/uploads/2021/09/unnamed.jpg?w=640'
    },
    {
      'name': 'โรงแรมดุสิตธานี',
      'review': 'บริการระดับโลก ห้องพักหรูหรา',
      'image': 'https://static.thairath.co.th/media/Dtbezn3nNUxytg04OS5oO2K0j8HH3N4zCFkaOEmFPS5o2K.jpg'
    },
    {
      'name': 'โรงแรมเมอร์เคียว',
      'review': 'ใกล้สถานีรถไฟฟ้า, บริการดีเยี่ยม',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx43MsN30_Xuk7Qff1Ajgn4-0ueAAfN69PnA&s'
    },
    {
      'name': 'โรงแรมอิมพีเรียล',
      'review': 'หรูหราและสะดวกสบาย',
      'image': 'https://q-xx.bstatic.com/xdata/images/hotel/max500/147533899.jpg?k=ee30fc1797df9aafeb1fae26d48bafb0ebc70d62048754ca50a4242591b64c26&o='
    },
    {
      'name': 'โรงแรมรอยัลการ์เด้น',
      'review': 'วิวสวยติดทะเล',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Royal_Garden_Plaza_Pattaya.jpg'
    },
    {
      'name': 'โรงแรมพาร์ค',
      'review': 'บริการมาตรฐานดีเยี่ยม',
      'image': 'https://www.mahajak.com/media/aw_blog/_-Park-Hyatt-Bangkok-Hotel.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredHotels = recommendedHotels
        .where((hotel) =>
            searchQuery.isEmpty ||
            hotel['name'].toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // ไปที่หน้ารายการจองของฉัน
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'ค้นหาโรงแรม',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: filteredHotels.isEmpty
                ? Center(
                    child: Text('ไม่พบโรงแรมที่ต้องการ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
                : ListView.builder(
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: ListTile(
                          leading: Image.network(
                            hotel['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 50),
                          ),
                          title: Text(hotel['name']),
                          subtitle: Text(hotel['review']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Newbooking(
                                  item: BookingItem(
                                    hotelName: hotel['name'],
                                    checkInDate: DateTime.now(), // ค่าตั้งต้น
                                    checkOutDate: DateTime.now()
                                        .add(Duration(days: 1)), // ค่าตั้งต้น
                                    price: 0.0, paymentMethod: '', roomType: '',
                                    keyID: null, bookingName: '', phoneNumber: '',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
