class Food {
  String id;
  final String nama;
  final int harga;
  final String jenis;
  final String images;
  final String resep;

  Food({
    this.id = "",
    required this.nama,
    required this.harga,
    required this.jenis,
    required this.images,
    required this.resep,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      nama: json['nama'] as String,
      harga: json['harga'] as int,
      jenis: json['jenis'] as String,
      images: json['images'] as String,
      resep: json['resep'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'jenis': jenis,
      'images': images,
      'resep': resep,
    };
  }
}
