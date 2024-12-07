import 'package:cloud_firestore/cloud_firestore.dart';

class SeriesEntity {
  const SeriesEntity({
    required this.seriesId,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.info,
    required this.rating,
    required this.questionNo,
  });

  factory SeriesEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return SeriesEntity.fromJson(data);
  }

  factory SeriesEntity.fromJson(Map<String, dynamic> json) {
    return SeriesEntity(
      seriesId: json['seriesId'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      description: json['description'] as String,
      info: json['info'] as String,
      rating: json['rating'] as String,
      questionNo: json['questionNo'] as int,
    );
  }
  final String seriesId;
  final String name;
  final String imgUrl;
  final String description;
  final String info;
  final String rating;
  final int questionNo;

  Map<String, dynamic> toJson() {
    return {
      'seriesId': seriesId,
      'name': name,
      'imgUrl': imgUrl,
      'description': description,
      'info': info,
      'rating': rating,
      'questionNo': questionNo,
    };
  }
}
