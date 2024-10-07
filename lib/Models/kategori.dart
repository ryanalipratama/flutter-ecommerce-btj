
class Kategori{
  final int id;
  final String nama_kategori;
  //final List<Produk> produk;
  
  Kategori({
    required this.id,
    required this.nama_kategori,
    //required this.produk
  });

  factory Kategori.fromJson(Map<String, dynamic> json)=>Kategori(
    id: json ['id'],
    nama_kategori: json['nama_kategori']

    // var produkJson = json['produk'] as List;
    // List<Produk> produkList = produkJson.map((produkJson) => Produk.fromJson(produkJson)).toList();

    // return Kategori(
    //   id: json["id"],
    //   nama_kategori: json['nama_kategori'],
    //   produk: produkList
    // );
  );
}