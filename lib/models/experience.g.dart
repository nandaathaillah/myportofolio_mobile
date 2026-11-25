// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Experience _$ExperienceFromJson(Map<String, dynamic> json) => Experience(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  isOngoing: json['is_ongoing'] as bool? ?? false,
  starCount: (json['star_count'] as num?)?.toInt() ?? 0,
  isStarred: json['is_starred'] as bool? ?? false,
  starredByNames: json['starred_by_names'] as String? ?? '',
);

Map<String, dynamic> _$ExperienceToJson(Experience instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'is_ongoing': instance.isOngoing,
    };
