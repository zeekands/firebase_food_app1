class Food {
  String id;
  final String nama;
  final int waktuPembuatan;
  final String deskripsi;
  final String jenis;
  final String images;
  final String resep;

  Food({
    this.id = "",
    required this.nama,
    required this.waktuPembuatan,
    required this.deskripsi,
    required this.jenis,
    required this.images,
    required this.resep,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String,
      waktuPembuatan: json['waktu_pembuatan'] as int,
      jenis: json['jenis'] as String,
      images: json['images'] as String,
      resep: json['resep'] as String,
    );
  }
}
