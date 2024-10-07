class BannerModel{
  final int id;
  final String gambar_banner;

  BannerModel({
    required this.id,
    required this.gambar_banner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json)=>BannerModel(
    id: json['id'],
    gambar_banner: json['gambar_banner']
  );
}