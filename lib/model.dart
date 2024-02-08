class LokerData {
  final int id;
  final String nama;
  final String noLoker;
  final String tanggal;
  final String idLoker;
  final String metodePembayaran;
  final int status;

  LokerData(
      {required this.id,
      required this.nama,
      required this.noLoker,
      required this.tanggal,
      required this.idLoker,
      required this.metodePembayaran,
      required this.status});

  factory LokerData.fromJson(Map<String, dynamic> json) {
    return LokerData(
      id: int.parse(json['id']),
      nama: json['nama'],
      noLoker: json['noLoker'],
      tanggal: json['tanggal'],
      idLoker: json['idLoker'],
      metodePembayaran: json['metodePembayaran'],
      status: int.parse(json['status']),
    );
  }
}
