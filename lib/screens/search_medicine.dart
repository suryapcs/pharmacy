import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/medicine_screen.dart';
import 'upload_prescription.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? loggedInUserId;
Set<String> cartItems = {};

class SearchMedicineScreen extends StatefulWidget {
  @override
  State<SearchMedicineScreen> createState() => _SearchMedicineScreenState();
}

class _SearchMedicineScreenState extends State<SearchMedicineScreen> {
  List<Medicine> displayMedicines = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    fetchMedicines();
  }

void loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("userId");
  if (userId == null) return;

  loggedInUserId = userId;

  // 🔥 fetch user cart from backend
  final cartData = await ApiService.getCart(userId);

  // cartData should be like [{medicineId: {...}, count: 1}, ...]
  // map medicineId to string
  setState(() {
    cartItems = cartData.map<String>((item) {
      // If backend is populated with populate('cart.medicineId'), item.medicineId might be object
      if (item['medicineId'] is Map) {
        return item['medicineId']['_id'].toString();
      } else {
        return item['medicineId'].toString();
      }
    }).toSet();
  });
}


  void fetchMedicines() async {
    final data = await ApiService.getAllMedicines();
    setState(() {
      displayMedicines = data
          .map<Medicine>((e) => Medicine.fromJson(e))
          .take(10)
          .toList();
      loading = false;
    });
  }

  void searchMedicine(String query) async {
    if (query.isEmpty) {
      fetchMedicines();
      return;
    }

    final data = await ApiService.searchMedicines(query);
    setState(() {
      displayMedicines = data
          .map<Medicine>((e) => Medicine.fromJson(e))
          .take(10)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchMedicine,
                    decoration: InputDecoration(
                      hintText: "Search medicine...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                /// 🔥 GRID VIEW
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72, // 🔥 image big
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),

                    itemCount: displayMedicines.length,
                    itemBuilder: (context, i) {
                      final med = displayMedicines[i];
                      print("IMAGE URL => ${med.image}");
                      return GestureDetector(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              /// 🖼️ FULL IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  med.image,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover, // 🔥 full cover
                                ),
                              ),

                              /// 🌑 GRADIENT (text readable)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// 🛒 CART ICON (TOP RIGHT)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
  icon: Icon(
    Icons.shopping_cart,
    color: cartItems.contains(med.id) ? Colors.red : Colors.grey,
  ),
  onPressed: () async {
    if (cartItems.contains(med.id)) {
      await ApiService.removeFromCart(loggedInUserId!, med.id);
      setState(() => cartItems.remove(med.id));
    } else {
      await ApiService.addToCart(loggedInUserId!, med.id);
      setState(() => cartItems.add(med.id));
    }
  },
)

                                ),
                              ),

                              /// 💊 NAME + PRICE (BOTTOM)
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "₹${med.price}",
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
