import './model.dart';

class LokerResponse {
  late List<LokerData> data;

  LokerResponse({required this.data});

  factory LokerResponse.fromJson(List<dynamic> json) {
    return LokerResponse(
      data: json.map((e) => LokerData.fromJson(e)).toList(),
    );
  }
}
