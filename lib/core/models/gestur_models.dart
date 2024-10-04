import 'dart:convert';

class GesturModel {
  final String category;
  final String linkVideo;
  final String terjemahan;
  final String id;

  GesturModel({
    required this.category,
    required this.linkVideo,
    required this.terjemahan,
    required this.id,
  });

  factory GesturModel.fromJson(Map<String, dynamic> json) {
    return GesturModel(
      category: json['Category'],
      linkVideo: json['Link_Video'],
      terjemahan: json['Terjemahan'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Category': category,
      'Link_Video': linkVideo,
      'Terjemahan': terjemahan,
      '_id': id,
    };
  }
}

List<GesturModel> gesturListFromJson(String str) => List<GesturModel>.from(
    json.decode(str).map((x) => GesturModel.fromJson(x)));

String gesturListToJson(List<GesturModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
