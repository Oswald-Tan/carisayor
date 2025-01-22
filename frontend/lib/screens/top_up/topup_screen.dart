import 'package:flutter/material.dart';
import 'package:frontend/screens/top_up/components/confirmation_modal.dart';
import 'package:frontend/screens/top_up/components/poin_selection.dart';
import 'package:frontend/screens/top_up/components/topinfo_instruction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/poin_service.dart';
import 'package:frontend/model/poin_model.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  static String routeName = "/topup";

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  List<Map<String, dynamic>> pointsOptions = [];
  int selectedPoints = 0; // Default selected points
  int pricePerPoint = 0;
  int discountPercentage = 0;
  int originalPrice = 0;
  int totalPrice = 0;

  // Function to handle point selection
  void onSelectPoints(int points, int price) {
    setState(() {
      selectedPoints = points;
      totalPrice = price;
    });
  }

  //fetch data points dari API
  Future<void> _loadPoints() async {
    try {
      PoinService poinService = PoinService();
      List<Poin> poinList = await poinService.fetchPoin(context);

      // Update points options dengan data dari API
      setState(() {
        pointsOptions = poinList
            .map((poin) => {
                  'points': poin.poin,
                  'price': poin.price,
                  'discountPercentage': poin.discountPercentage,
                  'originalPrice': poin.originalPrice
                })
            .toList();
      });
    } catch (e) {
      // Handle error
      print("Error fetching points: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPoints(); //panggil fungsi untuk memuat data poin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Top Up',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadPoints();
          },
          color: const Color(0xFF74B11A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopUpInfoInstruction(),
              const SizedBox(height: 20),

              //Poin selection
              pointsOptions.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loader if no data
                  : PointsSelection(
                      pointsOptions: pointsOptions,
                      selectedPoints: selectedPoints,
                      onSelectPoints: onSelectPoints,
                    ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedPoints > 0
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) {
                            return ConfirmationModal(
                              selectedPoints: selectedPoints,
                              totalPrice: totalPrice,
                            );
                          },
                          isScrollControlled: true,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74B11A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Proses',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
