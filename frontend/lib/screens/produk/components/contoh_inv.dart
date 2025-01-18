import 'package:flutter/material.dart';

class ContohInvoiceScreen extends StatelessWidget {
  final String customerName = "John Doe";
  final String orderDate = "17 Januari 2025";
  final List<Map<String, dynamic>> products = [
    {
      "name": "Bawang Putih",
      "quantity": 400,
      "pricePerUnit": 20000,
      "unit": 100
    },
    {"name": "Tomat", "quantity": 1, "pricePerUnit": 75000, "unit": 1},
    {
      "name": "Cabai Merah",
      "quantity": 300,
      "pricePerUnit": 30000,
      "unit": 100
    },
  ];
  final int shippingCost = 20000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Center(
              child: Text(
                "INVOICE",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFe9e8e8)),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Pesanan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Nama: "),
                        Text(customerName),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tanggal Pesanan: "),
                        Text(orderDate),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Color(0xFFe9e8e8),
                      thickness: 1,
                    ),
                    ...products.map((product) {
                      final int subtotal = product['unit'] == 100
                          ? (product['quantity'] *
                              (product['pricePerUnit'] as int) ~/
                              100)
                          : (product['quantity'] *
                              (product['pricePerUnit'] as int));

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Produk
                            Text(
                              "${product['name']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            // Jumlah dan Harga
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${product['quantity']} gram (per ${product['unit']} gram)",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  "Rp. ${subtotal.toString().replaceAllMapped(RegExp(r'\\B(?=(\\d{3})+(?!\\d))'), (match) => ".")}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            // Shipping Cost and Total
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFe9e8e8)),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ongkos Kirim",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Rp. ${shippingCost.toString().replaceAllMapped(RegExp(r'\\B(?=(\\d{3})+(?!\\d))'), (match) => ".")}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFFe9e8e8),
                      thickness: 1,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text(
                          "Rp 200.000",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
