class Produk {
  final int id;
  final String nama;
  final String deskripsi;
  final int hargaPoin;
  final int hargaRp;
  final int jumlah;
  final String satuan;
  final String? image;

  Produk({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.hargaPoin,
    required this.hargaRp,
    required this.jumlah,
    required this.satuan,
    this.image,
  });

  // Factory method untuk konversi dari JSON ke objek Produk
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nameProduk'],
      deskripsi: json['deskripsi'],
      hargaPoin: json['hargaPoin'],
      hargaRp: json['hargaRp'],
      jumlah: json['jumlah'],
      satuan: json['satuan'],
      image: json['image'],
    );
  }
}
