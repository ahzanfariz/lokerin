class LokerData {
  final int idEvent;
  final String name;
  final String category;
  final String dateTime;
  final String venue;
  final String description;
  final int price;

  LokerData({
    required this.idEvent,
    required this.name,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.price,
  });

  factory LokerData.fromJson(Map<String, dynamic> json) {
    return LokerData(
      idEvent: int.parse(json['id_event']),
      name: json['nama'],
      category: json['kategori'],
      dateTime: json['waktu'],
      venue: json['tempat'],
      description: json['deskripsi'],
      price: int.parse(json['harga']),
    );
  }
}
