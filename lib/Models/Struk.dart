class Struk{
  final DateTime tgl;
  final int userId;
  final String namaPelanggan;
  final String emailPelanggan;
  final String telepon;
  final String alamat;
  final int produkId;
  final String namaProduk;
  final double hargaProduk;
  final int qty;
  final int jasaPengiriman;
  final double biayaPengiriman;
  final double totalHarga;
  final String status;

  Struk({
    required this.tgl,
    required this.userId,
    required this.namaPelanggan,
    required this.emailPelanggan,
    required this.telepon,
    required this.alamat,
    required this.produkId,
    required this.namaProduk,
    required this.hargaProduk,
    required this.qty,
    required this.jasaPengiriman,
    required this.biayaPengiriman,
    required this.totalHarga,
    required this.status
});

factory Struk.fromJson(Map<String, dynamic> json){
  return Struk(
    tgl: DateTime.parse(json['tgl']),
    userId: json['user_id'],
    namaPelanggan: json['name'],
    emailPelanggan: json['email'],
    telepon: json['telepon'],
    alamat: json['alamat'],
    produkId: json['produk_id'],
    namaProduk: json['nama_produk'],
    hargaProduk: json['harga_produk'],
    qty: json['qty'],
    jasaPengiriman: json['jasa_pengiriman'],
    biayaPengiriman: json['biaya_pengiriman'],
    totalHarga: json['total_harga'],
    status: json['status'],
  );
}
}

